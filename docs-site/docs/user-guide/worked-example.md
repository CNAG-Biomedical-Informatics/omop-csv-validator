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
  --input example/DRUG_EXPOSURE.csv
```

## What this example shows

- a real OMOP table filename, `DRUG_EXPOSURE.csv`
- schema inference from the filename
- compatibility with OHDSI placeholder-qualified PostgreSQL DDL such as `@cdmDatabaseSchema.drug_exposure`

## If you adapt this example

Check these first:

- the filename still matches the intended OMOP table, or you pass `--table`
- the DDL file matches the CDM version you are targeting

:::warning Only override the separator if needed
The validator normally infers the delimiter automatically. Pass `--sep` only if the file is ambiguous or if you want to force a specific delimiter.
:::

## Related helper

If your input CSV has the right columns but the wrong order for downstream import workflows, see [Utilities](../reference/utilities.md).
