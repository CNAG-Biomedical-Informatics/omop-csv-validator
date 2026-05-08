---
sidebar_position: 1
---

# CLI Reference

## Command

```bash
bin/omop-csv-validator --ddl DDL.sql --input DATA.csv [options]
```

## Required options

### `--ddl`

Path to the PostgreSQL DDL file containing `CREATE TABLE` definitions.

### `--input`

Path to the input CSV file to validate.

## Optional options

### `--sep`

CSV field separator. Defaults to `,`.

Use `--sep $'\t'` for tab-separated files.

### `--table`, `-t`

Explicitly choose the table schema instead of inferring it from the CSV filename.

### `--save-schemas`

Write the generated schema set to a JSON file.

### `--no-color`, `-nc`

Disable ANSI color output.

### `--help`, `-h`

Show the built-in help text.

### `--version`, `-V`

Show the CLI version.

## Exit behavior

- exits `0` when validation succeeds
- exits `1` when validation errors are found
- dies early if required inputs are missing or a schema cannot be found
