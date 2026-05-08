---
sidebar_position: 2
---

# Benchmark

## Setup

These numbers come from a simple local synthetic run against the bundled OMOP 5.4 DDL using valid `PERSON.csv` rows and `--json`.

- Linux `5.4`
- `12` CPUs on the host
- single validator process
- no intra-file parallelism
- success-path validation only
- helper script in `bench/`

## Results

| Rows | File size | Default `--json` | `--json --turbo` |
| --- | ---: | ---: | ---: |
| 50K | 4.8 MB | 13.36 s | 2.47 s |
| 100K | 9.7 MB | 26.82 s | 4.75 s |
| 250K | 24.5 MB | 67.07 s | 11.61 s |
| 500K | 49.3 MB | 134.32 s | 23.29 s |

![Two-engine synthetic benchmark](/img/engine-benchmark.svg)

## Takeaway

The main result is straightforward: on this workload, `--turbo` is consistently much faster than the default engine.

For these local runs, the speedup was roughly:

- `5.4x` faster at 50K rows
- `5.6x` faster at 100K rows
- `5.8x` faster at 250K rows
- `5.8x` faster at 500K rows

So in practice:

- default engine: safer baseline, slower
- turbo engine: faster, but maintained as a second engine

## Recommendation

Use the default engine when:

- the CSV is not especially large
- you want the most conservative path

Use `--turbo` when:

- you are validating large files
- runtime is the main reason to switch
- you are staying within the current tested schema model

## Caveat

Treat these numbers as a local synthetic reference, not a guarantee. Real throughput will move with disk speed, CPU, row width, error rate, and report mode.
