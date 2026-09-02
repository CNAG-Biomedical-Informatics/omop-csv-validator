---
sidebar_position: 5
---

# Spreadsheet Reports

Spreadsheet reports are optional. The normal stdout message and exit status are enough for ordinary command-line use; generate a report only when someone needs to inspect or filter row-level results in spreadsheet software.

## What this feature does

The validator still reads OMOP table exports as text files:

- CSV
- TSV

It does **not** read `.xlsx` files as input.

Spreadsheet reporting is an optional output layer for users who review validation results in Excel or LibreOffice.

![OMOP CSV Validator report preview](/img/validation-report-preview.svg)

## Input vs output

### Input

The input is still one OMOP table export per run, for example:

- `PERSON.csv`
- `DRUG_EXPOSURE.csv`
- `OBSERVATION.csv`

If your source data starts in Excel, export the worksheet to CSV or TSV first, then run the validator on that exported file.

:::warning Separator override is usually unnecessary
The validator normally infers the delimiter automatically. Pass `--sep` only if the exported file needs an explicit override.
:::

### Output

You can ask the CLI to generate one of two spreadsheet-friendly outputs:

- `--report-tsv validation-report.tsv`
- `--report-xlsx validation-report.xlsx`

These are report files generated **in addition to** the normal validation result and exit code.

## TSV report

Use `--report-tsv` when you want a simple spreadsheet file with no extra Perl dependency beyond the normal CLI stack.

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input path/to/PERSON.csv \
  --report-tsv validation-report.tsv
```

The TSV report:

- keeps the original input columns
- adds `_validation_row`
- adds `_validation_status`
- adds `_validation_error_count`
- adds `_validation_messages`

This is useful when reviewers want to filter only `ERROR` rows and inspect the original values next to the validation message.

TSV does not carry Excel styling by itself, so there are no embedded colors in this mode.

## XLSX report

Use `--report-xlsx` when reviewers want a ready-to-open Excel workbook.

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input path/to/PERSON.csv \
  --report-xlsx validation-report.xlsx
```

The generated workbook contains:

- a `Summary` sheet
- a `Validation` sheet
- the original input columns
- the same `_validation_*` columns as the TSV report
- colored `OK` and `ERROR` status cells
- row highlighting, header freeze, and filters

This mode requires `Excel::Writer::XLSX`.

## Normal CLI behavior still applies

Report generation does not replace validation. The CLI still:

- exits `0` when validation succeeds
- exits `1` when validation errors are found
- exits `2` for fatal setup errors

The report contains the row-level details. The overall result still comes from the CLI output or `--json`.

:::note[Compact terminal output]

When you use `--report-tsv` or `--report-xlsx`, the CLI keeps stdout compact on validation failure. It does not print the full row-by-row error listing, because that detail is already present in the generated report.

:::

## Typical Excel workflow

1. Export one worksheet to `PERSON.csv` or `PERSON.tsv`.
2. Run the validator on that exported file.
3. Generate `--report-xlsx` if reviewers want a ready-made Excel workbook.
4. Filter the `Validation` sheet to `ERROR` rows and inspect `_validation_messages`.

## When to use which mode

- Use `--json` for R, Python, and workflow automation.
- Use `--report-tsv` for lightweight spreadsheet review.
- Use `--report-xlsx` when reviewers work primarily in Excel.
