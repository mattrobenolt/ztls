#!/usr/bin/env python3
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

repo = Path('/Users/matt/code/ztls')
out = Path(sys.argv[1])
out.mkdir(exist_ok=False)
probe = Path('/tmp/ztls-signoff-20260919/125-hkdf-probe.zig')
shutil.copy2(probe, out / 'probe.zig')
compilers = {
    '015': Path('/nix/store/4x0z07w3mxafc59b5dirkmllvqhav1i6-zig-0.15.2/bin/zig'),
    '016': Path('/nix/store/h4am1dpj4li41cq58861nysgaip7036s-zig-0.16.0/bin/zig'),
}
objdump = shutil.which('llvm-objdump')
assert objdump

def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def command(argv):
    return subprocess.check_output(argv, cwd=repo, text=True).strip()

manifest = {
    'purpose': 'Static HKDF lifetime audit. Cross-target objects are not execution or performance evidence.',
    'head': command(['git', 'rev-parse', 'HEAD']),
    'index_tree': command(['git', 'write-tree']),
    'status': command(['git', 'status', '--porcelain']),
    'probe_sha256': digest(probe),
    'objdump': objdump,
    'objdump_version': command([objdump, '--version']),
    'sources': {},
    'runs': [],
}
for name in ['src/hkdf.zig', 'src/memx.zig', 'src/ClientHandshake.zig',
             'src/ServerHandshake.zig', 'src/suite_state.zig', 'flake.lock']:
    manifest['sources'][name] = digest(repo / name)
for version, compiler in compilers.items():
    std = compiler.parent.parent / 'lib/zig/std'
    std_sources = {}
    for name in ['crypto/hkdf.zig', 'crypto/hmac.zig', 'crypto/sha2.zig', 'crypto.zig']:
        std_sources[str(std / name)] = digest(std / name)
    for arch in ['aarch64', 'x86_64']:
        for os_name in ['linux-gnu', 'macos']:
            target = arch + '-' + os_name
            stem = out / (version + '-' + target)
            argv = [str(compiler), 'build-obj', '-OReleaseFast', '-target', target,
                    '-mcpu', 'baseline', '--dep', 'ztls', '-Mroot=' + str(probe),
                    '-OReleaseFast', '-target', target, '-mcpu', 'baseline',
                    '-Mztls=' + str(repo / 'src/root.zig'), '-femit-bin=' + str(stem) + '.o']
            env = dict(os.environ, ZIG_GLOBAL_CACHE_DIR=str(out / ('global-' + version)),
                       ZIG_LOCAL_CACHE_DIR=str(out / ('cache-' + version)))
            with open(str(stem) + '.build.log', 'w') as log:
                subprocess.run(argv, cwd=repo, env=env, stdout=log, stderr=subprocess.STDOUT, check=True)
            disasm_argv = [objdump, '-dr', '--symbolize-operands', str(stem) + '.o']
            with open(str(stem) + '.asm', 'w') as log:
                subprocess.run(disasm_argv, stdout=log, stderr=subprocess.STDOUT, check=True)
            manifest['runs'].append({
                'compiler': str(compiler), 'compiler_sha256': digest(compiler),
                'version': command([str(compiler), 'version']), 'target': target,
                'argv': argv, 'disasm_argv': disasm_argv,
                'stdlib_sources': std_sources,
                'object_sha256': digest(str(stem) + '.o'),
                'assembly_sha256': digest(str(stem) + '.asm'),
            })
            (out / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
            print(version, target, 'captured', flush=True)
