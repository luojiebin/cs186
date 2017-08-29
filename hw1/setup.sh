#!/bin/bash

DATASET_DUMP=${1-lahman.pgdump}

set -e

rm -f "$DATASET_DUMP"
gunzip -k "${DATASET_DUMP}.gz"
dropdb --if-exists baseball
createdb baseball
psql -e -d baseball < "$DATASET_DUMP"
rm -f "$DATASET_DUMP"

echo -e '\nHW1 setup complete'

