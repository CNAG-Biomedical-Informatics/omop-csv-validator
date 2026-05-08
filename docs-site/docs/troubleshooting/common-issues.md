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

If the file is tab-separated but you leave the default comma separator, the header and rows will parse incorrectly.

Use:

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

In the current implementation, numeric coercion handles `\N` more cleanly than non-numeric date or timestamp fields. That means nullable non-numeric fields can still produce validation errors when `\N` is present.

Treat this as a known limitation of the current code rather than a docs issue.

## DDL parsing assumptions

The parser is intentionally simple. It expects PostgreSQL-style `CREATE TABLE` blocks and is not a general SQL parser.

Be cautious if your DDL differs in formatting, qualification style, or complexity.

## Large files and memory

The current validator reads the full CSV into memory before validating rows.

That is acceptable for many files, but it is not a streaming validator. For very large OMOP exports, memory usage can become material.
