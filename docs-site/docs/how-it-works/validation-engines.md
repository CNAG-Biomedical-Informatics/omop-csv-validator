---
sidebar_position: 1
---

# Validation Engines

The validator has two engines:

- the default engine is the `JSON::Validator` path
- the turbo engine is a specialized OMOP CSV row checker built from the same DDL-derived schema

The default engine is not legacy or deprecated. `--turbo` avoids the cost of running a general JSON Schema validator on every row of a large CSV.

![How the default and turbo validation engines share inputs and results](/img/validation-engines.svg)

## Validation flow

Both engines use the same preparation steps:

1. read PostgreSQL-style OMOP DDL
2. derive a schema for the selected table
3. stream through the CSV row by row
4. validate each normalized row with one of two engines

Both engines stream the CSV. They differ only in how they check each parsed row.

## Engines

### Default engine: `JSON::Validator`

This is the original engine and remains the default.

- uses `JSON::Validator`
- provides the reference behavior used in parity tests
- slower on large files

### Turbo engine: specialized row checks

This engine reduces validation time on large files.

- does not call `JSON::Validator` for each row
- compiles a lightweight per-table plan from the same DDL-derived schema
- checks required columns, nullability, and scalar types directly
- much faster on large files
- returns the same CLI outputs and exit codes

Use the default engine unless validation time is a problem. Use `--turbo` for large files or repeated runs.

## Parity

`t/05-turbo-parity.t` compares turbo results with the default engine for valid and invalid input.

## Benchmark

See [Benchmark](./benchmark.md) for local synthetic timings.
