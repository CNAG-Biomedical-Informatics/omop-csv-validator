---
sidebar_position: 2
---

# Validate a CSV

## Basic command

Use the validator by passing a DDL file and an input CSV file:

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input path/to/PERSON.csv
```

The command:

- loads table schemas from the DDL
- infers the table name from the CSV filename
- validates each row against that schema

## Field separator

The default separator is a comma.

For tab-separated files:

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input example/DRUG_EXPOSURE.csv \
  --sep $'\t'
```

## Override the inferred table name

If the CSV filename does not match the OMOP table name, pass `--table`:

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input path/to/export.csv \
  --table person
```

## Save the derived schemas

You can also write the generated schema set to JSON:

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input path/to/PERSON.csv \
  --save-schemas schemas.json
```

## Reading the result

If validation succeeds, the command exits with status `0` and prints a success message.

If validation fails, the command exits with status `1` and prints:

- the failing row
- one or more validator messages for that row

## What counts as a row

The CLI reports data-row positions, not header positions. When reviewing errors, interpret the reported row as a row in the data body of the CSV.
