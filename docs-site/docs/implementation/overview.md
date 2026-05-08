---
sidebar_position: 1
---

# Implementation

This section gives the short version of how the validator works internally and why there are now two validation engines.

## Validation flow

At a high level, the validator:

1. read PostgreSQL-style OMOP DDL
2. derive a schema for the selected table
3. stream through the CSV row by row
4. validate each normalized row with one of two engines

The important part is that the streaming model is shared by both engines and by all output modes. Large files do not take a different code path at the CLI level; the difference is only in how each row is checked once it has been parsed.

## Engines

### Default engine

This is the original path and still the default.

- uses `JSON::Validator`
- conservative and generic
- slower on large files

### Turbo engine

This is the faster path for heavier workloads.

- uses compiled per-column checks from the same DDL-derived schema
- much faster on large files
- keeps the same external CLI contract
- needs parity coverage because it is a second engine

In practice, the intent is simple: keep the default engine for ordinary use, and reach for `--turbo` when the CSV is large enough that runtime matters.

## Parity

Because `--turbo` is a second implementation, it is guarded by strict parity tests against the default path.

Main parity coverage:

- `t/05-turbo-parity.t`

## Benchmark

See [Benchmark](./benchmark.md) for the local synthetic timings and the practical tradeoff between the two engines.
