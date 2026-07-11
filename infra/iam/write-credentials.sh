#!/usr/bin/env bash
# Write a [ztls-bench] profile to ~/.aws/credentials from infra/iam tofu outputs.
#
# Run after: tofu -chdir=infra/iam apply
#
#   AWS_PROFILE=playground-ops infra/iam/write-credentials.sh
#
# Then use the credentials with:
#
#   AWS_PROFILE=ztls-bench just bench-regression-check
set -euo pipefail

cd "$(dirname "$0")/../.."

key_id="$(tofu -chdir=infra/iam output -raw access_key_id)"
secret="$(tofu -chdir=infra/iam output -raw secret_access_key)"
region="$(tofu -chdir=infra/iam output -raw region)"

aws_dir="${HOME}/.aws"
creds_file="${aws_dir}/credentials"

mkdir -p "${aws_dir}"

# If the file exists, remove any existing [ztls-bench] profile section first.
if [[ -f "${creds_file}" ]]; then
  # Delete from [ztls-bench] up to the next [profile] line or EOF.
  awk '
    /^\[ztls-bench\]/ { skip=1; next }
    /^\[/ { skip=0 }
    !skip { print }
  ' "${creds_file}" > "${creds_file}.tmp" && mv "${creds_file}.tmp" "${creds_file}"
fi

cat >> "${creds_file}" <<EOF
[ztls-bench]
aws_access_key_id = ${key_id}
aws_secret_access_key = ${secret}
region = ${region}
EOF

chmod 600 "${creds_file}"

echo "wrote [ztls-bench] profile to ${creds_file}"
echo "verify with: AWS_PROFILE=ztls-bench tofu -chdir=infra/bench plan"
