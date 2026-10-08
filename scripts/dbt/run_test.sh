#!/bin/bash

set -eo pipefail
IFS=$'\n\t'

TARGET_S3_BUCKET=$1
TARGET_S3_KEY=$2
# not used in this script,
# it is kept because it is called in Airflow by
# common_utils.dbt.test_taskgroup.dbt_test_taskgroup, which adds 4 args to the call
TARGET_PARTITION_VALUE=$3

copy_result_to_s3() {
  aws s3 cp /home/dbt/app/target/run_results.json s3://${TARGET_S3_BUCKET}/${TARGET_S3_KEY}/test_results.json
  aws s3 cp /home/dbt/app/target/manifest.json s3://${TARGET_S3_BUCKET}/${TARGET_S3_KEY}/manifest.json
  exit 0
}

trap copy_result_to_s3 EXIT

dbt test ${@:4}
