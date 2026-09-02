---
sidebar_position: 2
---

# Quick Start

The repository includes a valid `DRUG_EXPOSURE.csv`, a deliberately invalid `PERSON.csv`, and an OMOP CDM 5.4 PostgreSQL DDL file. The commands below use those files directly.

## Validate a file that passes

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input example/DRUG_EXPOSURE.csv
```

```text
✅ CSV file 'example/DRUG_EXPOSURE.csv' is valid against the 'DRUG_EXPOSURE' schema.
```

The command exits with status `0` because all four rows are valid.

## See a real validation error

The second row of `example/invalid/PERSON.csv` contains `A17` in the integer `person_id` field.

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input example/invalid/PERSON.csv \
  --no-color
```

```text
❌ Validation errors found:
⚠️  Row 2 validation failed:
   ✖ /person_id: Expected integer - got string.
```

The command exits with status `1`. The original CSV is not changed.

For command-line use, the message and exit status are usually enough. JSON, TSV, and XLSX provide the same result in other formats.

## Get the failure as JSON

Use `--json` when a script or workflow needs to read the result. It replaces the human-readable stdout with one JSON object; it does not create another file.

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input example/invalid/PERSON.csv \
  --json
```

```json
{"error_count":1,"input_file":"example/invalid/PERSON.csv","ok":false,"row_errors":[{"messages":["/person_id: Expected integer - got string."],"row":2}],"schema_name":"PERSON"}
```

## Write a TSV report

Use `--report-tsv` to create a row-level report for spreadsheet software. The CLI also prints a compact result and returns its normal exit status.

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input example/invalid/PERSON.csv \
  --report-tsv validation-report.tsv
```

The report contains every input column followed by the `_validation_*` columns. These selected columns show both input rows:

```text
person_id  year_of_birth  person_source_value  _validation_row  _validation_status  _validation_error_count  _validation_messages
1          1963           source1              1                OK                  0
A17        1963           source2              2                ERROR               1                        /person_id: Expected integer - got string.
```

## Write a colored XLSX report

Use `--report-xlsx` for the same optional report as a formatted Excel workbook.

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input example/invalid/PERSON.csv \
  --report-xlsx validation-report.xlsx
```

The workbook contains `Summary` and `Validation` worksheets. For this run, `Summary` records one valid row and one invalid row; `Validation` preserves the input and highlights each status.

![Validation worksheet showing one valid PERSON row and one row with an invalid person_id](/img/quick-start-xlsx-report.svg)

`--report-xlsx` requires `Excel::Writer::XLSX`, which is installed with the distribution dependencies.

For folder-level validation, see [Validate a Folder](./validate-a-folder.md). If a CSV needs canonical DDL column order for a later import, see [CSV Reorder Utility](../reference/csv-reorder-utility.md).

:::warning Only override the separator if needed
The validator normally infers the delimiter automatically. Pass `--sep` only if the file is ambiguous or if you want to force a specific delimiter.
:::
