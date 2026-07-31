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

:::important One CSV file per run
The CLI accepts one CSV file per run. It does not take multiple OMOP tables in a single invocation.

For folder-level validation, call the CLI once per CSV file.
:::

Validation is streamed row by row, so large files can be processed without loading the full input into memory first.

## Optional options

:::warning `--sep` is a fallback option
The validator normally infers the separator from the input file.

Use `--sep` only when you want to override detection explicitly or when the file is ambiguous, for example `--sep $'\t'`.
:::

### `--table`, `-t`

Explicitly choose the table schema instead of inferring it from the CSV filename.

### `--save-schemas`

Write the generated schema set to a JSON file.

### `--no-color`, `-nc`

Disable ANSI color output.

### `--json`

Emit a machine-readable JSON result object instead of the default human-readable output.

This is the recommended mode for R or other automation clients.

The CLI still validates the file row by row in this mode and only accumulates failing rows for the final `row_errors` payload.

### `--turbo`

Use the specialized fast-path validator instead of the default `JSON::Validator` engine.

The default engine validates each row through `JSON::Validator`, a general JSON Schema validation library.

`--turbo` builds a lightweight per-table plan from the same DDL-derived schema and checks each row directly. It is optional and is mainly intended for large CSV files where validation throughput becomes a practical issue.

For normal-sized files, stay on the default engine unless you have a specific reason to switch.

The default engine is not legacy. It is the generic validation baseline. `--turbo` is the specialized high-throughput path.

The external behavior stays the same:

- same exit codes
- same JSON output shape
- same row numbering
- same report formats

For implementation details and benchmark numbers, see [Validation Engines](../how-it-works/validation-engines.md).

### `--report-tsv`

Write a tab-separated validation report that spreadsheet users can open directly in Excel or LibreOffice.

The report keeps the original input columns and appends these validation columns:

- `_validation_row`
- `_validation_status`
- `_validation_error_count`
- `_validation_messages`

Use this when you want to sort, filter, or review failing rows in a spreadsheet.

The report is TSV, not native `.xlsx`, so it does not carry Excel cell colors by itself.

The report is written incrementally while the input is being validated, which makes this mode suitable for large files as well.

When this mode is enabled, the CLI keeps stdout compact on validation failure and does not print the full row-by-row error listing.

### `--report-xlsx`

Write a native Excel workbook with two sheets:

- `Summary`
- `Validation`

The `Validation` sheet keeps the original input columns and appends the same `_validation_*` columns used in the TSV report.

This mode also adds spreadsheet-oriented presentation:

- colored `OK` and `ERROR` status cells
- conditional row coloring in the validation sheet
- frozen header row and autofilter

Use this when your reviewers work primarily in Excel and want a ready-to-open workbook instead of plain text output.

When this mode is enabled, the CLI keeps stdout compact on validation failure and does not print the full row-by-row error listing.

The workbook rows are written as validation proceeds, so this mode does not require the full CSV to be held in memory first.

### `--help`, `-h`

Show the built-in help text.

### `--version`, `-V`

Show the CLI version.

## Exit behavior

- exits `0` when validation succeeds
- exits `1` when validation errors are found
- in `--json` mode, exits `2` for fatal setup errors such as a missing schema

## JSON output shape

When `--json` is enabled, the CLI writes one top-level result object with these fields:

- `input_file`
- `schema_name`
- `ok`
- `error_count`
- `row_errors`

For fatal setup errors, the object also includes:

- `fatal_error`

Each `row_errors` entry includes:

- `row`
- `messages`

## JSON contract stability

Treat `--json` as the supported automation interface for this tool.

That means the following are intended to remain stable for R, Python, and workflow clients:

- the top-level JSON object shape
- the documented keys
- the row-level `row` and `messages` fields
- exit code `0` for success
- exit code `1` for validation failures
- exit code `2` for fatal setup errors

Human-readable output is intended for interactive use and may change more freely than the JSON mode.
