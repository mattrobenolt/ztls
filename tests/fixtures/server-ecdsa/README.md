# Server ECDSA fixture

P-256 self-signed server certificate for in-memory ztls server handshake tests.
The private scalar is committed because this is a public test fixture, not a
trust anchor or production credential.

Subject/SAN:

```text
CN=ztls.server.test
DNS:ztls.server.test
```

Regenerate:

```sh
openssl ecparam -name prime256v1 -genkey -noout -out server.key
openssl req -x509 -new -key server.key -sha256 -days 3650 \
  -subj '/CN=ztls.server.test' -out server.crt \
  -addext 'basicConstraints=critical,CA:FALSE' \
  -addext 'keyUsage=critical,digitalSignature' \
  -addext 'extendedKeyUsage=serverAuth' \
  -addext 'subjectAltName=DNS:ztls.server.test'
openssl x509 -in server.crt -outform DER -out server.der
openssl ec -in server.key -noout -text > key.txt
uv run --script - <<'PY'
# /// script
# requires-python = ">=3.14"
# dependencies = []
# ///
import re, pathlib
text=pathlib.Path('key.txt').read_text().splitlines()
out=[]; flag=False
for line in text:
    if 'priv:' in line:
        flag=True; continue
    if 'pub:' in line:
        flag=False
    if flag:
        out.append(re.sub(r'[^0-9a-fA-F]', '', line))
pathlib.Path('scalar.bin').write_bytes(bytes.fromhex(''.join(out)))
PY
```
