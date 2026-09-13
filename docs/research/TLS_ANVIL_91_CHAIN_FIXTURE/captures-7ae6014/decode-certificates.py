"""Extract public certificates from this capture's diagnostic handshake flights."""

import hashlib
from pathlib import Path
import re
import subprocess
import sys

source = Path(__file__).parent / "aws-lc" / "invocations"
output = Path(sys.argv[1])
output.mkdir(parents=True, exist_ok=True)
for log in sorted(source.glob("*.stderr")):
    text = log.read_text()
    port = re.search(r"local_port=(\d+)", text)[1]
    flight = bytes.fromhex("".join(re.findall(r"cert_hex=([0-9a-f]+)", text)))
    cursor = 0
    index = 0
    while cursor < len(flight):
        assert cursor + 4 <= len(flight)
        kind = flight[cursor]
        length = int.from_bytes(flight[cursor + 1 : cursor + 4], "big")
        cursor += 4
        assert cursor + length <= len(flight)
        body = flight[cursor : cursor + length]
        cursor += length
        if kind != 11:
            continue
        assert body
        pos = 1 + body[0]
        assert pos + 3 <= len(body)
        size = int.from_bytes(body[pos : pos + 3], "big")
        pos += 3
        assert pos + size == len(body)
        while pos < len(body):
            assert pos + 3 <= len(body)
            size = int.from_bytes(body[pos : pos + 3], "big")
            pos += 3
            assert pos + size + 2 <= len(body)
            der = body[pos : pos + size]
            pos += size
            extensions = int.from_bytes(body[pos : pos + 2], "big")
            pos += 2 + extensions
            assert pos <= len(body)
            destination = output / f"{port}-{index}.pem"
            subprocess.run(
                ["openssl", "x509", "-inform", "DER", "-out", str(destination)],
                input=der,
                check=True,
            )
            print(destination.name, hashlib.sha256(der).hexdigest(), flush=True)
            subprocess.run(
                ["openssl", "x509", "-in", str(destination), "-noout", "-dates"],
                check=True,
            )
            index += 1
    assert index == 2
