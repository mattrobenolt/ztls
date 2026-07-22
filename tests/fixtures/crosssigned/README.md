# X.509 cross-signed root fixtures

Small P-256 certificate chain exercising trusted-first path building:

```text
root CA (self-signed, in bundle) -> intermediate CA -> leaf cross.test
```

The twist: the server presents a third certificate, a **cross-signed root** —
the root's subject and public key, but signed by an *untrusted* anchor that is
not in the bundle. This mirrors production chains like example.com's, where
`SSL.com TLS ECC Root CA 2022` is presented cross-signed by Comodo
`AAA Certificate Services` (not in most bundles) while the self-signed
`SSL.com TLS ECC Root CA 2022` is. A verifier that only anchors the *last*
presented certificate fails with issuer-not-found; trusted-first path building
anchors the intermediate against the self-signed root instead.

```text
presented: leaf cross.test -> intermediate -> cross-signed root (issuer: untrusted anchor)
bundle:    root CA (self-signed)
expected:  OK — anchor the intermediate against the root CA
```

The leaf has SAN `DNS:cross.test`. Only the self-signed root is on disk as
PEM (`root.crt`, loaded into the test bundle via `addCertsFromFilePath`); the
leaf/intermediate/cross-signed DERs live in `../fixtures.txtar` as
`crosssigned_*` sections.

Regenerate with OpenSSL:

```sh
# root: the trust anchor that WILL be in the bundle (self-signed)
openssl ecparam -name prime256v1 -genkey -noout -out root.key
openssl req -x509 -new -key root.key -sha256 -days 3650 \
  -subj '/CN=ztls crosssign root' -out root.crt \
  -addext 'basicConstraints=critical,CA:TRUE,pathlen:1' \
  -addext 'keyUsage=critical,keyCertSign,cRLSign' \
  -addext 'subjectKeyIdentifier=hash'

# other: an untrusted anchor (NOT in the bundle) that cross-signs root's key
openssl ecparam -name prime256v1 -genkey -noout -out other.key
openssl req -x509 -new -key other.key -sha256 -days 3650 \
  -subj '/CN=ztls crosssign untrusted anchor' -out other.crt \
  -addext 'basicConstraints=critical,CA:TRUE' \
  -addext 'keyUsage=critical,keyCertSign,cRLSign' \
  -addext 'subjectKeyIdentifier=hash'

# cross: root's subject + key, but issued by the untrusted anchor
openssl req -new -key root.key -subj '/CN=ztls crosssign root' -out cross.csr
cat > cross.ext <<'EOF'
basicConstraints=critical,CA:TRUE,pathlen:1
keyUsage=critical,keyCertSign,cRLSign
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
EOF
openssl x509 -req -in cross.csr -CA other.crt -CAkey other.key \
  -CAcreateserial -out cross.crt -days 3000 -sha256 -extfile cross.ext

# intermediate issued by root
openssl ecparam -name prime256v1 -genkey -noout -out intermediate.key
openssl req -new -key intermediate.key \
  -subj '/CN=ztls crosssign intermediate' -out intermediate.csr
cat > intermediate.ext <<'EOF'
basicConstraints=critical,CA:TRUE,pathlen:0
keyUsage=critical,keyCertSign,cRLSign
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
EOF
openssl x509 -req -in intermediate.csr -CA root.crt -CAkey root.key \
  -CAcreateserial -out intermediate.crt -days 2000 -sha256 \
  -extfile intermediate.ext

# leaf
openssl ecparam -name prime256v1 -genkey -noout -out leaf.key
openssl req -new -key leaf.key -subj '/CN=cross.test' -out leaf.csr
cat > leaf.ext <<'EOF'
basicConstraints=critical,CA:FALSE
keyUsage=critical,digitalSignature
extendedKeyUsage=serverAuth
subjectAltName=DNS:cross.test
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
EOF
openssl x509 -req -in leaf.csr -CA intermediate.crt -CAkey intermediate.key \
  -CAcreateserial -out leaf.crt -days 1000 -sha256 -extfile leaf.ext

openssl verify -CAfile root.crt -untrusted intermediate.crt leaf.crt
```

Private keys and CSRs are intentionally not committed; the tests only need certs.
