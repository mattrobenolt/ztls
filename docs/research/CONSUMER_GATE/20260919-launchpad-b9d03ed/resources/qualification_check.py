"""Bounded TLS checks against private handoff processes. No deployment changes."""
import contextlib
import json
import os
from pathlib import Path
import ssl
import time

from bench import check

out = Path(os.environ['QUALIFICATION_OUTPUT'])
out.mkdir(exist_ok=False)
check.PORT = 18443
check.OUTPUT_DIR = out
check.BACKEND_SOCK = str(out / 'backend.sock')
os.environ['HANDOFF_EXTRA_ARGS'] = '--port 18443'


class VerifiedContext(ssl.SSLContext):
    def wrap_socket(self, *args, **kwargs):
        kwargs.setdefault('server_hostname', 'localhost')
        return super().wrap_socket(*args, **kwargs)


def verified_context():
    ctx = VerifiedContext(ssl.PROTOCOL_TLS_CLIENT)
    ctx.load_verify_locations(cafile=check.CERT_PEM)
    # Match create_default_context: the committed fixture leaf is the explicit trust anchor.
    ctx.verify_flags |= ssl.VERIFY_X509_PARTIAL_CHAIN | ssl.VERIFY_X509_STRICT
    ctx.minimum_version = ctx.maximum_version = ssl.TLSVersion.TLSv1_3
    return ctx


check._ssl_context = verified_context
original_running = check.running
samples = []


def sample_children():
    children = Path(f'/proc/{os.getpid()}/task/{os.getpid()}/children').read_text().split()
    result = {}
    for pid in children:
        proc = Path('/proc') / pid
        try:
            name = (proc / 'comm').read_text().strip()
            if not name.startswith('handoff'):
                continue
            status = (proc / 'status').read_text().splitlines()
            rss = next(int(line.split()[1]) for line in status if line.startswith('VmRSS:'))
            result[pid] = {'name': name, 'fds': len(list((proc / 'fd').iterdir())), 'rss_kib': rss}
        except FileNotFoundError:
            continue
    return result


@contextlib.contextmanager
def observed_running(*args, **kwargs):
    phase = kwargs.get('label', kwargs.get('behavior', 'echo'))
    with original_running(*args, **kwargs):
        time.sleep(0.2)
        before = sample_children()
        assert len(before) == 2, before
        try:
            yield
        except BaseException:
            samples.append({'phase': phase, 'outcome': 'failed', 'before': before, 'after': sample_children()})
            (out / 'resources.json').write_text(json.dumps(samples, indent=2) + '\n')
            raise
        else:
            # Give close completions a bounded interval before the quiescent sample.
            deadline = time.monotonic() + 5
            while True:
                after = sample_children()
                if after.keys() == before.keys() and all(after[p]['fds'] <= before[p]['fds'] for p in before):
                    break
                if time.monotonic() >= deadline:
                    raise AssertionError(('file descriptors did not return', before, after))
                time.sleep(0.02)
            samples.append({'phase': phase, 'before': before, 'after': after})
            (out / 'resources.json').write_text(json.dumps(samples, indent=2) + '\n')
            assert all(value['rss_kib'] < 65536 for value in after.values()), after


check.running = observed_running
raise SystemExit(check.run_check('tls'))
