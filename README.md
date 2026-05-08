# OMOP CSV Validator

OMOP CSV Validator is a small Perl CLI and module for validating OMOP CDM CSV files against schemas derived from PostgreSQL DDL.

## What it does

- parses `CREATE TABLE` definitions from OMOP DDL
- derives JSON Schema-like validation rules from those tables
- validates CSV rows against the inferred schema
- exposes both a CLI and a reusable Perl module

## Documentation

Project documentation now lives in the local Docusaurus site under [docs-site](docs-site/README.md).

Main entry points:

- [Docs overview](docs-site/docs/overview.md)
- [Installation](docs-site/docs/user-guide/installation.md)
- [Validate a CSV](docs-site/docs/user-guide/validate-a-csv.md)
- [CLI reference](docs-site/docs/reference/cli.md)
- [Troubleshooting](docs-site/docs/troubleshooting/common-issues.md)

## Quick start

Install dependencies:

```bash
cpanm -n --installdeps .
```

Validate a CSV file:

```bash
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input example/DRUG_EXPOSURE.csv \
  --sep $'\t'
```

Run tests:

```bash
prove -l t/
```

## Notes

- The validator is currently geared toward PostgreSQL-style OMOP DDL files.
- Some edge cases and behavioral caveats are documented explicitly in the troubleshooting pages instead of being hidden in the README.

## License

Released under the [Artistic License 2.0](LICENSE).
