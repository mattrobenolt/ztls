#!/usr/bin/env bash
set -euo pipefail
out="${1:?usage: generate.sh OUTPUT_DIRECTORY}"
mkdir -p "$out"
cd "$out"
openssl ecparam -name prime256v1 -genkey -noout -out root.key
openssl req -x509 -new -key root.key -sha256 -days 3650 \
  -subj '/CN=ztls key capacity root' -out root.crt \
  -addext 'basicConstraints=critical,CA:TRUE' \
  -addext 'keyUsage=critical,keyCertSign,cRLSign'
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:8192 -out leaf.key
openssl req -new -key leaf.key -subj '/CN=capacity.test' -out leaf.csr
printf '%s\n' 'basicConstraints=critical,CA:FALSE' \
  'keyUsage=critical,digitalSignature' 'extendedKeyUsage=serverAuth,clientAuth' \
  'subjectAltName=DNS:capacity.test' > leaf.ext
openssl x509 -req -in leaf.csr -CA root.crt -CAkey root.key -CAcreateserial \
  -out leaf.crt -days 1000 -sha256 -extfile leaf.ext
openssl x509 -in root.crt -outform DER -out root.der
openssl x509 -in leaf.crt -outform DER -out leaf.der
openssl verify -CAfile root.crt -purpose sslserver -verify_hostname capacity.test leaf.crt
openssl verify -CAfile root.crt -purpose sslclient leaf.crt
openssl pkey -in leaf.key -pubout -outform DER -out leaf.spki.der
wc -c root.der leaf.der leaf.spki.der
