---
sidebar_position: 2
---

# Module API

The main Perl module is `OMOP::CSV::Validator`.

This page summarizes the public methods at a practical level. For formal POD, see the module source.

## Constructor

### `new`

Creates a validator object.

```perl
my $validator = OMOP::CSV::Validator->new();
```

## Schema loading

### `load_schemas_from_ddl($ddl_text)`

Parses DDL text and returns a hash reference keyed by lowercase table name.

The parser accepts:

- schema-qualified PostgreSQL table names
- unqualified table names
- OHDSI-style placeholder qualifiers such as `@cdmDatabaseSchema.person`

Typical use:

```perl
my $ddl_text = path($ddl_file)->slurp_utf8;
my $schemas = $validator->load_schemas_from_ddl($ddl_text);
```

## Table selection

### `get_schema_from_csv_filename($csv_filename, $schemas)`

Derives the table name from the CSV basename and returns the matching schema.

## Validation

### `validate_csv_file($csv_file, $schema, $sep)`

Reads a CSV file, coerces numeric-looking values where configured, validates each row, and returns an array reference of validation errors.

`$sep` is optional and defaults to `,`.

The returned error entries use data-row numbering. The first row after the CSV header is row `1`.

The validator also normalizes OMOP-style `\N` markers to null values before validation.

## Numeric coercion helper

### `dotify_and_coerce_number($val)`

Normalizes decimal commas to dots and returns a numeric value when the input looks numeric.

This helper is used internally during validation and is exposed as part of the module surface today.
