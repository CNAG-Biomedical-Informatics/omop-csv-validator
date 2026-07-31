---
sidebar_position: 1
---

# Validation Engines

This section gives the short version of how the validator works internally and why there are two validation engines.

The names can be misleading if you only see them weeks later:

- the default engine is the `JSON::Validator` path
- the turbo engine is a specialized OMOP CSV row checker built from the same DDL-derived schema

The default engine is not legacy. It remains the conservative baseline. `--turbo` exists because the generic JSON Schema validation path is expensive when applied row by row to large CSV files.

![How the default and turbo validation engines share inputs and results](/img/validation-engines.svg)

## Validation flow

At a high level, the validator:

1. read PostgreSQL-style OMOP DDL
2. derive a schema for the selected table
3. stream through the CSV row by row
4. validate each normalized row with one of two engines

The important part is that the streaming model is shared by both engines and by all output modes. Large files do not take a different code path at the CLI level; the difference is only in how each row is checked once it has been parsed.

## Engines

### Default engine: `JSON::Validator`

This is the original path and still the default.

- uses `JSON::Validator`
- validates rows through a general JSON Schema validation library
- conservative baseline for behavior
- slower on large files

### Turbo engine: specialized row checks

This is the faster path for heavier workloads.

- does not call `JSON::Validator` for each row
- compiles a lightweight per-table plan from the same DDL-derived schema
- checks required columns, nullability, and scalar types directly
- much faster on large files
- keeps the same external CLI contract
- needs parity coverage because it is a second engine

In practice, the intent is simple: keep the default `JSON::Validator` engine for ordinary use, and reach for `--turbo` when the CSV is large enough that runtime matters.

## What `--turbo` does not mean

`--turbo` does not mean that the default engine is deprecated, abandoned, or unsafe.

It means:

- use the generic validator path by default
- use the specialized row-check path when throughput matters
- expect the same documented CLI outputs from both paths

## Parity

Because `--turbo` is a second implementation, it is guarded by strict parity tests against the default path.

Main parity coverage:

- `t/05-turbo-parity.t`

## Benchmark

See [Benchmark](./benchmark.md) for the local synthetic timings and the practical tradeoff between the two engines.
