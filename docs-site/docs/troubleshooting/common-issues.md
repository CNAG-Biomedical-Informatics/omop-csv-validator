---
sidebar_position: 1
---

# Common Issues

## No schema found for the CSV file

This usually means the CSV filename does not match the target OMOP table name.

Fix it by either:

- renaming the file to match the table, such as `PERSON.csv`
- passing `--table person`

## Wrong separator

Separator inference usually works automatically. If the CLI reports an ambiguous separator or parses the file incorrectly, rerun with an explicit override such as:

```bash
--sep $'\t'
```

## Timestamp and date validation failures

The validator maps:

- `date` to JSON Schema `date`
- `timestamp` to JSON Schema `date-time`

That means date-only strings in timestamp columns can fail validation.

## `\N` null handling caveat

OMOP-style exports often use `\N` as a null marker.

The validator now normalizes `\N` to null values before validation, including nullable date, timestamp, and varchar fields.

If you still see errors, the most likely cause is that the target column is not nullable in the DDL-derived schema.

## DDL parsing assumptions

The parser is intentionally simple. It expects PostgreSQL-style `CREATE TABLE` blocks and is not a general SQL parser.

It does handle common OMOP forms such as:

- schema-qualified names like `public.person`
- placeholder-qualified names like `@cdmDatabaseSchema.person`
- unqualified names like `person`

Be cautious if your DDL differs materially from those patterns.

## Large files and memory

The validator now processes CSV input row by row instead of loading the whole file before validation starts.

That makes it suitable for large OMOP exports.

In practice:

- default human-readable validation starts reporting against streamed rows
- `--json` mainly accumulates failing rows in memory
- `--report-tsv` writes rows incrementally
- `--report-xlsx` writes workbook rows incrementally

Memory usage can still grow if a very large number of rows fail or if you generate large report artifacts, but it no longer scales with the entire input file in the same way as a full in-memory read.
