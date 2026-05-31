# X.509 chain fixtures

Small P-256 certificate chain for ztls unit tests:

```text
root CA -> intermediate CA -> leaf chain.test
```

The leaf has SANs:

```text
DNS:chain.test
DNS:www.chain.test
```

Regenerate with OpenSSL:

```sh
openssl ecparam -name prime256v1 -genkey -noout -out root.key
openssl req -x509 -new -key root.key -sha256 -days 3650 \
  -subj '/CN=ztls test root' -out root.crt \
  -addext 'basicConstraints=critical,CA:TRUE,pathlen:1' \
  -addext 'keyUsage=critical,keyCertSign,cRLSign' \
  -addext 'subjectKeyIdentifier=hash'

openssl ecparam -name prime256v1 -genkey -noout -out intermediate.key
openssl req -new -key intermediate.key \
  -subj '/CN=ztls test intermediate' -out intermediate.csr
cat > intermediate.ext <<'EOF'
basicConstraints=critical,CA:TRUE,pathlen:0
keyUsage=critical,keyCertSign,cRLSign
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
EOF
openssl x509 -req -in intermediate.csr -CA root.crt -CAkey root.key \
  -CAcreateserial -out intermediate.crt -days 2000 -sha256 \
  -extfile intermediate.ext

openssl ecparam -name prime256v1 -genkey -noout -out leaf.key
openssl req -new -key leaf.key -subj '/CN=chain.test' -out leaf.csr
cat > leaf.ext <<'EOF'
basicConstraints=critical,CA:FALSE
keyUsage=critical,digitalSignature
extendedKeyUsage=serverAuth
subjectAltName=DNS:chain.test,DNS:www.chain.test
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
EOF
openssl x509 -req -in leaf.csr -CA intermediate.crt -CAkey intermediate.key \
  -CAcreateserial -out leaf.crt -days 1000 -sha256 -extfile leaf.ext

openssl x509 -in root.crt -outform DER -out root.der
openssl x509 -in intermediate.crt -outform DER -out intermediate.der
openssl x509 -in leaf.crt -outform DER -out leaf.der
openssl verify -CAfile root.crt -untrusted intermediate.crt leaf.crt
```

Private keys and CSRs are intentionally not committed; the tests only need certs.
