#!/usr/bin/env bash
set -euo pipefail
out="${1:?usage: generate.sh OUTPUT_DIRECTORY}"
mkdir -p "$out"
cd "$out"
openssl ecparam -name prime256v1 -genkey -noout -out root.key
openssl req -x509 -new -key root.key -sha256 -days 3650 \
  -subj '/CN=ztls extension root' -out root.crt \
  -addext 'basicConstraints=critical,CA:TRUE' \
  -addext 'keyUsage=critical,keyCertSign,cRLSign'
openssl ecparam -name prime256v1 -genkey -noout -out leaf.key
openssl req -new -key leaf.key -subj '/CN=critical.test' -out leaf.csr
for kind in valid ignored critical san_application san_context san_private san_set san_primitive; do
  {
    printf '%s\n' 'basicConstraints=critical,CA:FALSE' 'keyUsage=critical,digitalSignature' 'extendedKeyUsage=serverAuth,clientAuth'
    case "$kind" in
      san_application) tag=70 ;;
      san_context) tag=b0 ;;
      san_private) tag=f0 ;;
      san_set) tag=31 ;;
      san_primitive) tag=10 ;;
      *) tag=30 ;;
    esac
    printf 'subjectAltName=DER:%s:0f:82:0d:63:72:69:74:69:63:61:6c:2e:74:65:73:74\n' "$tag"
    case "$kind" in
      critical) printf '%s\n' 'nsComment=critical,fixture' ;;
      ignored) printf '%s\n' 'nsComment=fixture' ;;
      *) ;;
    esac
  } > "$kind.ext"
  openssl x509 -req -in leaf.csr -CA root.crt -CAkey root.key -CAcreateserial \
    -out "$kind.crt" -days 1000 -sha256 -extfile "$kind.ext"
  openssl x509 -in "$kind.crt" -outform DER -out "$kind.der"
done
