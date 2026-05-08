---
sidebar_position: 3
---

# Worked Example

The repository includes a sample OMOP CSV file and a bundled PostgreSQL DDL file.

## Example validation

Run:

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input example/DRUG_EXPOSURE.csv \
  --sep $'\t'
```

## What this example shows

- a real OMOP table filename, `DRUG_EXPOSURE.csv`
- explicit tab-separated input
- schema inference from the filename

## If you adapt this example

Check these first:

- the filename still matches the intended OMOP table, or you pass `--table`
- the separator matches the file you are validating
- the DDL file matches the CDM version you are targeting

## Related helper

If your input CSV has the right columns but the wrong order for downstream import workflows, see [Utilities](../reference/utilities.md).
