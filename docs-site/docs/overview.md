---
sidebar_position: 1
---

# OMOP CSV Validator

OMOP CSV Validator checks OMOP CDM CSV files before they are loaded into a database.

Use it during ETL development and testing to find invalid exports before they reach PostgreSQL.

The validator derives its rules from OMOP PostgreSQL DDL and processes the CSV row by row. It does not load the full file into memory.

![OMOP CSV Validator pre-ingestion workflow](/img/pre-ingestion-validation.svg)

## What it is for

- checking whether a CSV matches DDL-derived columns and types before database ingestion
- finding invalid rows before loading the export
- printing terminal or JSON results and generating optional TSV or XLSX reports
- using the same validation logic from a CLI or from Perl code

## Core workflow

The validator works in four steps:

1. read PostgreSQL DDL containing `CREATE TABLE` statements
2. derive a schema for each OMOP table
3. stream through the CSV and validate each row against the selected table schema
4. report issues before the file reaches PostgreSQL

## Included commands and module

- `bin/omop-csv-validator`: command-line validator
- `lib/OMOP/CSV/Validator.pm`: Perl module
- `utils/reorder-csv.pl`: reorders CSV columns to match DDL order

## Requirements and limits

- The DDL must use PostgreSQL-style `CREATE TABLE` statements.
- The CSV filename must identify its OMOP table unless `--table` is supplied.
- Each command validates one CSV file against one OMOP table.

Known limitations are described in [Troubleshooting](./troubleshooting/common-issues.md).
