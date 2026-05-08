# Bench

This directory is for local benchmarking and profiling of the validator.

Tracked files here should stay small and reusable, such as helper scripts or notes.

Generated artifacts are intentionally ignored:

- `bench/generated/`
- `bench/results/`
- `bench/nytprof/`

## Synthetic benchmark

Run the synthetic engine benchmark with:

```bash
bench/run_synthetic_validation_benchmark.sh
```

By default it benchmarks these row counts:

- `50000`
- `100000`
- `250000`
- `500000`

The script writes:

- generated CSV input to `bench/generated/`
- timing results to `bench/results/engine-benchmark.csv`

The output includes both engines:

- default `--json`
- `--json --turbo`

## NYTProf

This directory is also the intended place for local profiler output.

Example:

```bash
mkdir -p bench/nytprof
NYTPROF=file=bench/nytprof/nytprof.out \
  perl -d:NYTProf bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input bench/generated/PERSON.csv \
  --json
```
