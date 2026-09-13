# TLS-Anvil validity diagnostics

Run: https://github.com/mattrobenolt/ztls/actions/runs/34735309314

The AWS-LC capture uses clean revision `7ae60147aedc54dbed42085078764572db119f3c` with `ZTLS_ANVIL_DIAGNOSTICS=1`.
The installed jar, class, and patch source hashes match the recorded build provenance.
Project status and residual scope remain in `PRODUCTION_READINESS.md` (#91).

The capture contains 14 client invocations with `CertificateExpired` and complete server Certificate messages.
Each message contains two certificates with identical `notBefore` and `notAfter` values.
The client policy clock equals its real clock and exceeds both certificate timestamps by exactly one second.
`aws-lc/validity.json` records the clocks, DER hashes, OpenSSL output, and port associations.

Seven invocation ports match recorded case destination ports.
Each matched case starts less than 30 milliseconds after its client invocation.
Those cases span four methods and report four strict successes and three conceptual successes.
They include `verifyFinishedMessageCorrect` and `sendCertificateVerifyGreaseSignatureAlgorithm`.
The certificate rejection precedes Finished or CertificateVerify validation, so those results do not prove that the intended validation ran.
The other seven invocations have no destination-port match in the recorded case results.
Their purpose is not inferred from adjacent timestamps.

The generated certificate dates explain these captured expiry rejections.
They do not establish the cause of the earlier KeyUpdate or client-authentication failures, whose certificate bytes were not captured.
The source of the zero-length validity windows requires a separate reproduction.

## Files

- `aws-lc/summary.*`: original normalized aggregate results.
- `aws-lc/run_metadata.json`: original capture provenance.
- `aws-lc/invocations/`: original stderr from the 14 rejected connections.
- `aws-lc/cases/`: original case reports with destination-port matches.
- `aws-lc/certificates/`: public certificates extracted from the diagnostic flights, encoded as PEM.
- `decode-certificates.py`: a decoder for this capture, not a general TLS parser.

## Reproduce the certificate extraction

Run the decoder with an output directory outside the repository:

```sh
python3 docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/captures-7ae6014/decode-certificates.py /tmp/anvil-validity-certificates
```

Compare the PEM files:

```sh
diff -r /tmp/anvil-validity-certificates docs/research/TLS_ANVIL_91_CHAIN_FIXTURE/captures-7ae6014/aws-lc/certificates
```
