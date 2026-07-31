---
sidebar_position: 3
---

# CSV Reorder Utility

`utils/reorder-csv.pl` is a supporting utility for reordering CSV columns to match the order defined in a DDL file.

:::note[Not required for validation]

You do **not** need to reorder columns before using `omop-csv-validator`.

The validator matches data by header name, so validation is header-based rather than position-based.

:::

![Why CSV column reordering can be useful before positional database loading](/img/csv-reorder-utility.svg)

## When you need it

`reorder-csv.pl` is useful when a downstream step expects columns in canonical OMOP table order, for example:

- a PostgreSQL `COPY` or `\copy` workflow that loads fields positionally
- a SQLite `.import` workflow that loads fields positionally
- a loader that assumes table-order columns
- an exchange or normalization step where you want a consistent DDL-derived layout

It is useful when:

- your source CSV contains the right fields but not in the expected order
- you want a DDL-driven reorder step before import or in other tooling where column position matters

## Typical workflow

In most cases the flow is:

1. validate the exported file as-is
2. reorder it only if the next tool expects canonical column order
3. import or hand off the reordered file

If your PostgreSQL load command already provides an explicit column list, you may not need reordering at all.

## Example

```bash
utils/reorder-csv.pl \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input PERSON.csv \
  --output PERSON.reordered.csv
```

For a SQLite DDL:

```bash
utils/reorder-csv.pl \
  --ddl ddl/OMOPCDM_sqlite_5.4_ddl.sql \
  --ddl-type sqlite \
  --input PERSON.csv \
  --output PERSON.reordered.csv
```

## Quick SQLite debugging workflow

If you want a lightweight local check before loading into PostgreSQL, SQLite can be useful for quick debugging.

The important detail is that SQLite `.import` is positional. That is why reordering can matter here even though validation itself does not require ordered columns.

Example:

```bash
bin/omop-csv-validator \
  --ddl path/to/OMOPCDM_sqlite_5.4_ddl.sql \
  --input PERSON.csv

utils/reorder-csv.pl \
  --ddl path/to/OMOPCDM_sqlite_5.4_ddl.sql \
  --ddl-type sqlite \
  --input PERSON.csv \
  --output PERSON.reordered.csv

sqlite3 omop_debug.db <<'EOF'
.read path/to/OMOPCDM_sqlite_5.4_ddl.sql
.mode csv
.separator "\t"
.import '| tail -n +2 PERSON.reordered.csv' person
SELECT COUNT(*) FROM person;
EOF
```

This is useful for:

- quick local sanity checks
- debugging transformed exports
- checking whether a reordered file can be loaded structurally before moving to PostgreSQL

It is not a substitute for a full PostgreSQL load when you need production-faithful behavior.

## Notes

- this script is a helper, not the main validation entry point
- it is mainly for downstream load preparation, not for core validation
- it supports `--table` if the filename does not map cleanly to the target table
- it defaults `--ddl-type` to `postgresql`
- it inserts `\N` for missing columns in the reordered output
- it drops extra input columns that are not present in the target DDL order
- it can infer the separator, but `--sep` is still available as an override
