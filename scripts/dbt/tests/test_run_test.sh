#!/bin/bash

set -eo pipefail
IFS=$'\n\t'

aws() {
    echo aws $@
}

dbt() {
    echo dbt $@
}

show_tests_result() {
    [[ $? -ne 0 ]] && echo "❌️ Tests have not passed!" || echo "✅️ All tests passed!"
}

trap show_tests_result EXIT

ACTUAL=$(source ./run_test.sh my_s3_bucket my_s3_key my_execution_date --vars "{insert_date_ci: '2023-10-10'}")

echo "$ACTUAL" | grep "dbt test --vars {insert_date_ci: '2023-10-10'}" > /dev/null
echo "$ACTUAL" | grep "aws s3 cp /home/dbt/app/target/run_results.json s3://my_s3_bucket/my_s3_key/test_results.json" > /dev/null
echo "$ACTUAL" | grep "aws s3 cp /home/dbt/app/target/manifest.json s3://my_s3_bucket/my_s3_key/manifest.json" > /dev/null
