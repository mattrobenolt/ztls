# Consumer candidate gate

`scripts/consumer-gate.sh` tests one committed ztls revision against handoff and z53 (#119).
The gate archives the candidate and replaces each consumer dependency pin inside a private clone.
It does not modify the original consumer checkout or the live service.

Read `PRODUCTION_READINESS.md` for qualification status.

## Ownership

ztls owns candidate selection, isolated checkouts, dependency substitution, and the evidence record.
Each consumer owns its test commands and development environment.

| Consumer | Delegated commands | Source |
|---|---|---|
| handoff | `just test`, then Debug and ReleaseFast builds in TLS and plaintext modes | Consumer `Justfile` and `.github/workflows/handoff.yaml` |
| z53 | `just test` | Consumer `Justfile` and `.github/workflows/ci.yml` |

The record identifies the exact consumer revisions and executed commands.
These commands cover consumer compatibility, not every consumer CI job or production deployment.
The initial host profile is Linux aarch64, with AWS-LC for handoff and OpenSSL for z53.
Other profiles require separate captures.

## Run a candidate

1. Enter the ztls Nix development shell.
2. Set `CONSUMER_GATE_HANDOFF_REPO` to the handoff repository path or clone URL.
3. Set `CONSUMER_GATE_Z53_REPO` to the z53 repository path or clone URL.
4. Select full commit SHAs for ztls and both consumers.
5. Select a new evidence directory.
6. Run the qualification command:

```sh
just qualify-candidate "$ztls_sha" "$handoff_sha" "$z53_sha" "$out_dir"
```

## Records and failure behavior

The gate rejects symbolic revisions in qualification mode, duplicate consumers, and existing output directories.
Each capture contains:

- `run.json`: candidate SHA, archive digest, package hash, consumer revisions, toolchain, and command results.
- `consumers/<name>/record.json`: original dependency pin, candidate pin, and consumer result.
- `logs/`: dependency substitution, toolchain probes, and command output.
- `summary.txt`: result and qualification limits.

Exit zero means that all requested consumer commands passed.
Exit one means that a consumer command failed.
Exit two means that the harness failed before a complete record.
A subset run does not qualify both consumers.
A candidate identical to the original package pin does not test an upgrade.

The archive comes from the selected commit, not uncommitted source files.
Private local caches prevent reuse of compiled artifacts from another candidate.
The optional gate cache stores downloaded packages outside the operator's shared Zig cache.
Temporary clones and archives are deleted unless `--keep-work` is present.
The recorded original URL and package hash provide the rollback pin.

## Pre-1.0 updates

Consumer updates use immutable commit SHAs and Zig package hashes, not moving branches.
A candidate gate result authorizes neither a consumer pin update nor a deployment.
After an accepted update, rollback restores the recorded original URL and hash together.
API changes remain possible before 1.0.

## Harness checks

`just consumer-gate-selftest` exercises parsing, JSON escaping, revision guards, duplicate detection, and evidence-directory protection.
Both root CI recipes run these checks.
A broken-import candidate tests compile-failure propagation.
A candidate without hostname verification tests authentication-failure detection in the real z53 suite.
Those negative captures do not replace a successful run of the selected candidate.
