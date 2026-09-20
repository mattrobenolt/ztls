#!/usr/bin/env python3
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys

memory = Path(sys.argv[1]).resolve()
out = Path(sys.argv[2]).resolve()
out.mkdir(exist_ok=False)
binary = memory / 'bin/bin/test'
for path in memory.iterdir():
    if path.is_file():
        shutil.copy2(path, out / path.name)
names = {
    'ClientHandshake.processServerHello': 'client-sh',
    'ClientHandshake.clientFinished': 'client-finished',
    'ServerHandshake.processClientHelloMessage': 'server-ch',
    'hybrid_kex.deriveClassicalSecret': 'hybrid-classical',
    'x25519.sharedSecret': 'x25519',
    'p256.sharedSecret': 'p256',
    'p384.sharedSecret': 'p384',
}
argv = ['llvm-nm', '-S', '--defined-only', str(binary)]
symbols = subprocess.check_output(argv, text=True)
manifest = {
    'binary': str(binary),
    'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(),
    'symbols_argv': argv,
    'functions': [],
}
selected = []
for line in symbols.splitlines():
    fields = line.split(maxsplit=3)
    if len(fields) != 4:
        continue
    symbol = fields[3]
    filename = names.get(symbol)
    if symbol.startswith('hkdf.Hkdf(') and symbol.endswith('.makeRecordLayer'):
        filename = 'make-layer-' + ('256' if 'Sha2x32' in symbol else '384')
    if filename is None:
        continue
    start, size = int(fields[0], 16), int(fields[1], 16)
    argv = ['llvm-objdump', '-dr', '--symbolize-operands',
            '--start-address=' + hex(start), '--stop-address=' + hex(start + size), str(binary)]
    path = out / (filename + '.asm')
    with path.open('w') as stream:
        subprocess.run(argv, stdout=stream, stderr=subprocess.STDOUT, check=True)
    selected.append(line)
    manifest['functions'].append({
        'symbol': symbol, 'start': hex(start), 'size': size, 'argv': argv,
        'assembly': path.name, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
    })
(out / 'selected-symbols.txt').write_text('\n'.join(selected) + '\n')
(out / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
print(out, len(selected), 'functions')
