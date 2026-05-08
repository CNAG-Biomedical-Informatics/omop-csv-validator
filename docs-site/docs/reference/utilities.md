---
sidebar_position: 3
---

# Utilities

## `reorder-csv.pl`

`utils/reorder-csv.pl` is a supporting utility for reordering CSV columns to match the order defined in a DDL file.

It is useful when:

- your source CSV contains the right fields but not in the expected order
- you want a DDL-driven reorder step before import or validation in other tooling

## Example

```bash
utils/reorder-csv.pl \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --ddl-type postgresql \
  --input PERSON.csv \
  --output PERSON.reordered.csv \
  --sep $'\t'
```

## Notes

- this script is a helper, not the main validation entry point
- it supports `--table` if the filename does not map cleanly to the target table
- it inserts `\N` for missing columns in the reordered output
- it currently expects an explicit `--ddl-type`, unlike the main validator CLI
