import hashlib
import json
from pathlib import Path
import shutil
import subprocess

root = Path('/tmp/ztls-signoff-20260919')
out = root / 'aws-lc-cache-final'
out.mkdir()
zig = '/nix/store/h4am1dpj4li41cq58861nysgaip7036s-zig-0.16.0/bin/zig'
libdir = '/nix/store/3hnfh4dzrjjncnpa9nhggr6l7m97g456-aws-lc-5.5.0/lib'
records = []
for name in ['main-1', 'main-512', 'thread-512']:
    source = out / (name + '.zig')
    shutil.copy2(root / 'aws-lc-cache-probes' / source.name, source)
    binary = out / name
    build = [zig, 'build-exe', str(source), '-OReleaseSafe', '-mcpu=baseline', '-lc', '-lcrypto', '-L' + libdir, '-rpath', libdir, '-femit-bin=' + str(binary)]
    subprocess.run(build, check=True)
    command = ['timeout', '120', 'valgrind', '--leak-check=full', '--show-leak-kinds=all', '--errors-for-leak-kinds=all', '--track-origins=yes', '--error-exitcode=99', '--log-file=' + str(out / (name + '.valgrind.log')), str(binary)]
    with (out / (name + '.output.log')).open('w') as log:
        result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT)
    expected = 0 if name == 'thread-512' else 99
    (out / (name + '.exit')).write_text(str(result.returncode) + '\n')
    assert result.returncode == expected
    text = (out / (name + '.valgrind.log')).read_text()
    assert ('in use at exit: 0 bytes in 0 blocks' if expected == 0 else 'in use at exit: 1,232 bytes in 5 blocks') in text
    (out / (name + '.binding.txt')).write_text(subprocess.check_output(['ldd', str(binary)], text=True))
    records.append({'name': name, 'build': build, 'command': command, 'exit': result.returncode, 'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(), 'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest()})
metadata = {'host': subprocess.check_output(['uname', '-a'], text=True).strip(), 'zig_version': subprocess.check_output([zig, 'version'], text=True).strip(), 'valgrind_version': subprocess.check_output(['valgrind', '--version'], text=True).strip(), 'provider': 'AWS-LC 5.5.0', 'provider_library': libdir + '/libcrypto.so', 'provider_sha256': hashlib.sha256(Path(libdir + '/libcrypto.so').read_bytes()).hexdigest(), 'records': records}
(out / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
print('AWS_LC_FIXED_THREAD_STATE_REPRODUCED')
