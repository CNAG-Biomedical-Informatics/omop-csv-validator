---
sidebar_position: 1
---

# OMOP CSV Validator

OMOP CSV Validator is a small Perl project for validating OMOP CDM CSV extracts against rules derived from PostgreSQL DDL.

## What it is for

- checking whether a CSV file matches the expected OMOP table structure
- validating column types without hand-writing table-specific validators
- using the same validation logic from a CLI or from Perl code

## Core workflow

The validator works in three steps:

1. read PostgreSQL DDL containing `CREATE TABLE` statements
2. derive a schema for each table
3. validate each CSV row against the selected table schema

## Project surfaces

- `bin/omop-csv-validator`
  - main command-line interface
- `lib/OMOP/CSV/Validator.pm`
  - reusable Perl module
- `utils/reorder-csv.pl`
  - helper script for reordering CSV columns to match DDL order

## What these docs optimize for

This documentation is intentionally narrower than the docs in larger application repositories.

It focuses on:

- installation and local use
- the main validation workflow
- command reference
- real caveats you are likely to hit with OMOP exports

It does not attempt to present this project as a larger platform than it is.

## Current boundaries

These docs assume:

- PostgreSQL-style OMOP DDL files
- CSV files whose table name can be inferred from the filename, unless overridden
- local execution by analysts or developers working with OMOP extracts

Known limitations are described in [Troubleshooting](./troubleshooting/common-issues.md).
