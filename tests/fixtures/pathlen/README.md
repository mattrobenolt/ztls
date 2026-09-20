# X.509 pathLenConstraint fixtures (#118)

P-256 certificate families exercising RFC 5280 §4.2.1.9 / §6.1 path-length
enforcement during ztls chain verification (#118). Four roots live here as
loose PEM (loaded into test bundles via `addCertsFromFilePath`); every
presented-chain certificate is a `pathlen_*` DER section in `../fixtures.txtar`
with an extractor in `../fixtures.zig`.

```text
root               CA, no constraint        (root.crt)          — zero/one/multi/absent anchor
root_plc1          CA, pathlen:1            (root_plc1.crt)     — trust-anchor constraint family
crosssign_root     CA, no constraint        (crosssign_root.crt)
crosssign_untrusted CA, no constraint       (crosssign_untrusted.crt) — issues the cross-signed root only
```

Families (all intermediates CA:TRUE + keyCertSign, all leaves serverAuth EKU
except the `client_*` leaves, which carry no EKU so they satisfy client-auth
policy):

```text
root      -> zero_inter(plc:0) -> below_zero_inter      B: reject — non-self-issued intermediate below plc:0
                            |-> self_issued_inter(self-issued) -> below_si_inter
                            |                                Q4b: reject — below_si_inter still counts
                            |-> below_zero_leaf/client_*  A: accept — target excluded
                            |-> ca_target(CA, plc:0)      A: accept — final CA certificate not counted
root      -> one_inter(plc:1)  -> one_mid_inter -> one_deep_inter
                            |                     D: reject — two intermediates below plc:1
                            |-> one_leaf            C: accept — exactly one
root      -> multi_outer(plc:2) -> multi_inner(plc:0) -> multi_deep_inter
                            |                      Q2: reject — inner plc:0 binds, outer plc:2 allows
                            |-> multi_leaf           Q1: accept — both satisfied
root      -> absent_a -> absent_b -> absent_leaf      E: accept — absent constraint imposes no limit
root_plc1 -> anchor_mid -> anchor_deep -> anchor_deep_leaf  AN1: reject — anchor's own pathlen:1
root_plc1 -> anchor_mid -> anchor_leaf                    AN2: accept — one intermediate <= 1
crosssign_root     -> cross_mid -> cross_deep -> cross_leaf
crosssign_untrusted -> cross_root_cross(plc:0)  — cross-signing of crosssign_root's
                                                    subject+key, presented above cross_mid
CS1: [cross_leaf, cross_deep, cross_mid, cross_root_cross] + crosssign_root   accept —
     trusted-first anchors at cross_mid; certificates above the anchored
     certificate are outside the path (RFC 5280 §6.1) and cross_root_cross's
     pathlen:0 does not apply.
CS2: same presented chain + crosssign_untrusted                                reject —
     cross_root_cross is now in the path and its pathlen:0 binds.
```

## OpenSSL ground truth

The parent repeated all 13 cases below on 2026-09-19 with OpenSSL 3.6.4 on Linux aarch64.
The client-auth acceptance and rejection cases also matched.
The commands used `-attime 1800000000`, which matches the Zig tests.
Every reject is `error 25 at N depth lookup: path length constraint exceeded`,
attributed to the constraining certificate. The ztls tests in
`src/certificate.zig` cite these verdicts per case.

```console
$ openssl verify -CAfile root.crt -untrusted <(cat below_zero_inter.crt zero_inter.crt) below_zero_leaf.crt
CN=ztls pathlen zero
error 25 at 2 depth lookup: path length constraint exceeded      (B: zero_inter, plc:0)
$ openssl verify -CAfile root.crt -untrusted zero_inter.crt ca_target_leaf.crt
ca_target_leaf.crt: OK                                           (A)
$ openssl verify -CAfile root.crt -untrusted <(cat one_inter.crt one_mid_inter.crt one_deep_inter.crt) one_deep_leaf.crt
CN=ztls pathlen one
error 25 at 3 depth lookup: path length constraint exceeded      (D: one_inter, plc:1)
$ openssl verify -CAfile root.crt -untrusted <(cat one_inter.crt one_mid_inter.crt) one_leaf.crt
one_leaf.crt: OK                                                 (C)
$ openssl verify -CAfile root.crt -untrusted <(cat absent_a_inter.crt absent_b_inter.crt) absent_leaf.crt
absent_leaf.crt: OK                                              (E)
$ openssl verify -CAfile root.crt -untrusted <(cat multi_outer_inter.crt multi_inner_inter.crt multi_deep_inter.crt) multi_deep_leaf.crt
CN=ztls pathlen multi inner
error 25 at 2 depth lookup: path length constraint exceeded      (Q2: multi_inner, plc:0)
$ openssl verify -CAfile root.crt -untrusted <(cat multi_outer_inter.crt multi_inner_inter.crt) multi_leaf.crt
multi_leaf.crt: OK                                               (Q1)
$ openssl verify -CAfile root.crt -untrusted <(cat zero_inter.crt self_issued_inter.crt) self_issued_leaf.crt
self_issued_leaf.crt: OK                                         (Q4a: self-issued not counted)
$ openssl verify -CAfile root.crt -untrusted <(cat zero_inter.crt self_issued_inter.crt below_si_inter.crt) below_si_leaf.crt
CN=ztls pathlen zero
error 25 at 3 depth lookup: path length constraint exceeded      (Q4b)
$ openssl verify -CAfile root_plc1.crt -untrusted <(cat anchor_mid_inter.crt anchor_deep_inter.crt) anchor_deep_leaf.crt
CN=ztls pathlen anchor root
error 25 at 3 depth lookup: path length constraint exceeded      (AN1: the trust anchor itself)
$ openssl verify -CAfile root_plc1.crt -untrusted anchor_mid_inter.crt anchor_leaf.crt
anchor_leaf.crt: OK                                              (AN2)
$ openssl verify -CAfile crosssign_root.crt -untrusted <(cat cross_root_cross.crt cross_mid_inter.crt cross_deep_inter.crt) cross_leaf.crt
cross_leaf.crt: OK                                               (CS1)
$ openssl verify -CAfile crosssign_untrusted.crt -untrusted <(cat cross_root_cross.crt cross_mid_inter.crt cross_deep_inter.crt) cross_leaf.crt
CN=ztls pathlen crosssign root
error 25 at 3 depth lookup: path length constraint exceeded      (CS2: cross_root_cross in path)
```

## Trust-anchor semantics

The trust anchor is not part of the prospective path under RFC 5280 §6.1.1.
ztls applies its `pathLenConstraint` as local policy under §6.2, not as a requirement of the base algorithm.
RFC 5280 §6.2 marks applying an anchor's path-length constraint as a permitted
local policy ("An implementation MAY ... apply a path length constraint to a
specific trust anchor during the initialization phase"). OpenSSL 3.6.4 does
apply it (AN1 attributes the failure to the anchor certificate at the top of
its chain), and ztls matches that behavior for bundle anchors: the anchor's
`pathLenConstraint` seeds the initial `max_path_length` (§6.1.2(k)). The
anchor-first walk also means a presented self-signed root that matches the
bundle anchor is skipped by the §6.1.4(l) budget check exactly because it is
self-issued, so presenting the root in the chain changes nothing.

## Regenerate with OpenSSL

Private keys and CSRs are intentionally not committed; the tests only need
certs. After regenerating, re-record the ground-truth table above, refresh the
`pathlen_*` sections in `../fixtures.txtar` (`openssl x509 -outform DER |
base64 -w 0`), and copy the four roots' PEM into this directory.

```sh
set -euo pipefail
d=$(mktemp -d)
cd "$d"

mkroot() { # name cn plc
  openssl ecparam -name prime256v1 -genkey -noout -out "$1.key"
  openssl req -x509 -new -key "$1.key" -sha256 -days 3650 \
    -subj "/CN=$2" -out "$1.crt" \
    -addext 'basicConstraints=critical,CA:TRUE'"${3:+,$3}" \
    -addext 'keyUsage=critical,keyCertSign,cRLSign' \
    -addext 'subjectKeyIdentifier=hash'
}
mkinter() { # name issuer_crt issuer_key plc subject_cn
  openssl ecparam -name prime256v1 -genkey -noout -out "$1.key"
  openssl req -new -key "$1.key" -subj "/CN=$5" -out "$1.csr"
  { echo 'basicConstraints=critical,CA:TRUE'"${4:+,$4}"
    echo 'keyUsage=critical,keyCertSign,cRLSign'
    echo 'subjectKeyIdentifier=hash'
    echo 'authorityKeyIdentifier=keyid,issuer'
  } > "$1.ext"
  openssl x509 -req -in "$1.csr" -CA "$2" -CAkey "$3" \
    -CAcreateserial -out "$1.crt" -days 2000 -sha256 -extfile "$1.ext"
}
mkleaf() { # name issuer_crt issuer_key san eku ca
  openssl ecparam -name prime256v1 -genkey -noout -out "$1.key"
  openssl req -new -key "$1.key" -subj "/CN=$4" -out "$1.csr"
  { if [ "$6" = "ca" ]; then
      echo 'basicConstraints=critical,CA:TRUE,pathlen:0'
      echo 'keyUsage=critical,digitalSignature,keyCertSign'
    else
      echo 'basicConstraints=critical,CA:FALSE'
      echo 'keyUsage=critical,digitalSignature'
    fi
    if [ "$5" = "server" ]; then echo 'extendedKeyUsage=serverAuth'; fi
    echo "subjectAltName=DNS:$4"
    echo 'subjectKeyIdentifier=hash'
    echo 'authorityKeyIdentifier=keyid,issuer'
  } > "$1.ext"
  openssl x509 -req -in "$1.csr" -CA "$2" -CAkey "$3" \
    -CAcreateserial -out "$1.crt" -days 1000 -sha256 -extfile "$1.ext"
}

mkroot root "ztls pathlen root" ""
mkroot root_plc1 "ztls pathlen anchor root" "pathlen:1"
mkroot crosssign_root "ztls pathlen crosssign root" ""
mkroot crosssign_untrusted "ztls pathlen crosssign untrusted" ""

mkinter zero_inter root.crt root.key "pathlen:0" "ztls pathlen zero"
mkinter below_zero_inter zero_inter.crt zero_inter.key "" "ztls pathlen below zero"
# self-issued: same subject DN as its issuer
mkinter self_issued_inter zero_inter.crt zero_inter.key "" "ztls pathlen zero"
mkinter below_si_inter self_issued_inter.crt self_issued_inter.key "" "ztls pathlen below si"
mkleaf below_zero_leaf below_zero_inter.crt below_zero_inter.key below-zero.test server no
mkleaf self_issued_leaf self_issued_inter.crt self_issued_inter.key selfissued.test server no
mkleaf below_si_leaf below_si_inter.crt below_si_inter.key below-si.test server no
mkleaf ca_target_leaf zero_inter.crt zero_inter.key catarget.test server ca
mkleaf client_below_zero_leaf below_zero_inter.crt below_zero_inter.key client-below-zero.test none no
mkleaf client_zero_leaf zero_inter.crt zero_inter.key client-zero.test none no

mkinter one_inter root.crt root.key "pathlen:1" "ztls pathlen one"
mkinter one_mid_inter one_inter.crt one_inter.key "" "ztls pathlen one mid"
mkinter one_deep_inter one_mid_inter.crt one_mid_inter.key "" "ztls pathlen one deep"
mkleaf one_leaf one_mid_inter.crt one_mid_inter.key one.test server no
mkleaf one_deep_leaf one_deep_inter.crt one_deep_inter.key one-deep.test server no

mkinter multi_outer_inter root.crt root.key "pathlen:2" "ztls pathlen multi outer"
mkinter multi_inner_inter multi_outer_inter.crt multi_outer_inter.key "pathlen:0" "ztls pathlen multi inner"
mkinter multi_deep_inter multi_inner_inter.crt multi_inner_inter.key "" "ztls pathlen multi deep"
mkleaf multi_leaf multi_inner_inter.crt multi_inner_inter.key multi.test server no
mkleaf multi_deep_leaf multi_deep_inter.crt multi_deep_inter.key multi-deep.test server no

mkinter absent_a_inter root.crt root.key "" "ztls pathlen absent a"
mkinter absent_b_inter absent_a_inter.crt absent_a_inter.key "" "ztls pathlen absent b"
mkleaf absent_leaf absent_b_inter.crt absent_b_inter.key absent.test server no

mkinter anchor_mid_inter root_plc1.crt root_plc1.key "" "ztls pathlen anchor mid"
mkinter anchor_deep_inter anchor_mid_inter.crt anchor_mid_inter.key "" "ztls pathlen anchor deep"
mkleaf anchor_leaf anchor_mid_inter.crt anchor_mid_inter.key anchor.test server no
mkleaf anchor_deep_leaf anchor_deep_inter.crt anchor_deep_inter.key anchor-deep.test server no

# cross-signing of crosssign_root's subject+key by the untrusted anchor
openssl req -new -key crosssign_root.key -subj '/CN=ztls pathlen crosssign root' -out cross_root_cross.csr
{ echo 'basicConstraints=critical,CA:TRUE,pathlen:0'
  echo 'keyUsage=critical,keyCertSign,cRLSign'
  echo 'subjectKeyIdentifier=hash'
  echo 'authorityKeyIdentifier=keyid,issuer'
} > cross_root_cross.ext
openssl x509 -req -in cross_root_cross.csr -CA crosssign_untrusted.crt \
  -CAkey crosssign_untrusted.key -CAcreateserial -out cross_root_cross.crt \
  -days 3000 -sha256 -extfile cross_root_cross.ext
mkinter cross_mid_inter crosssign_root.crt crosssign_root.key "" "ztls pathlen cross mid"
mkinter cross_deep_inter cross_mid_inter.crt cross_mid_inter.key "" "ztls pathlen cross deep"
mkleaf cross_leaf cross_deep_inter.crt cross_deep_inter.key cross.test server no
```
