---
sidebar_position: 4
---

# Validate a Folder

The CLI accepts one CSV file per invocation, so validating a folder means running the same command once for each OMOP table export.

## Basic loop

```bash
for csv in exports/*.csv; do
  echo "Validating $csv"
  omop-csv-validator \
    --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
    --input "$csv"
done
```

Each file produces its own validation result and exit status. The filename is used to select the OMOP table schema, so files should normally be named after their tables, such as `PERSON.csv` or `DRUG_EXPOSURE.csv`.

## Preserve a folder-level exit status

This Bash loop continues after failures and exits with the most severe result returned by any file:

```bash
overall=0

for csv in exports/*.csv; do
  omop-csv-validator \
    --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
    --input "$csv" \
    --json

  result=$?
  if ((result > overall)); then
    overall=$result
  fi
done

exit "$overall"
```

The resulting status follows the normal CLI contract:

- `0`: every CSV is valid
- `1`: at least one CSV contains validation errors
- `2`: at least one run could not start or complete

## Use a workflow language

R and Python use the same one-file-per-command model and parse the same `--json` result:

- [Use from R](./use-from-r.md)
- [Use from Python](./use-from-python.md)

Workflow managers can apply the same pattern by creating one task for each CSV file.
