<p align="center">
  <a href="https://cnag-biomedical-informatics.github.io/omop-csv-validator/"><img src="https://raw.githubusercontent.com/CNAG-Biomedical-Informatics/omop-csv-validator/main/docs-site/static/img/omop-csv-validator-logo.png" width="180" alt="OMOP CSV Validator"></a>
</p>
<p align="center">
  <em>Validate OMOP CDM CSV exports before database ingestion</em>
</p>

[![Build and test](https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator/actions/workflows/build-and-test.yml)
[![Documentation](https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator/actions/workflows/documentation.yml/badge.svg)](https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator/actions/workflows/documentation.yml)
[![CPAN version](https://img.shields.io/cpan/v/OMOP-CSV-Validator.svg)](https://metacpan.org/release/OMOP-CSV-Validator)
[![Coverage](https://coveralls.io/repos/github/CNAG-Biomedical-Informatics/omop-csv-validator/badge.svg?branch=main)](https://coveralls.io/github/CNAG-Biomedical-Informatics/omop-csv-validator?branch=main)
[![License](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](LICENSE)

# OMOP CSV Validator

OMOP CSV Validator checks the columns, nulls, and scalar values in an OMOP CDM CSV export before the file is loaded into a database. It derives the validation rules from PostgreSQL OMOP DDL, so ETL development can use the same table definitions as the target database.

[Documentation](https://cnag-biomedical-informatics.github.io/omop-csv-validator/) · [MetaCPAN](https://metacpan.org/pod/OMOP::CSV::Validator)

## Install

OMOP CSV Validator is used as a command-line program; using it does not require writing or understanding Perl. The standard CPAN client is included with Perl:

```bash
cpan OMOP::CSV::Validator
```

For an isolated runtime with no host Perl-module setup:

```bash
docker run --rm manuelrueda/omop-csv-validator:0.05 --version
```

See [Installation](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/user-guide/installation) for `cpanm`, Docker, Apptainer, development, and non-`sudo` options.

## Validate one table export

```bash
omop-csv-validator \
  --ddl path/to/OMOPCDM_postgresql_5.4_ddl.sql \
  --input path/to/DRUG_EXPOSURE.csv
```

```text
✅ CSV file 'path/to/DRUG_EXPOSURE.csv' is valid against the 'DRUG_EXPOSURE' schema.
```

Each invocation validates one CSV file against one OMOP table. For a runnable repository example, failure output, folder loops, JSON automation, and spreadsheet reports, use the documentation links below.

![Command-line and spreadsheet validation results](https://raw.githubusercontent.com/CNAG-Biomedical-Informatics/omop-csv-validator/main/docs-site/static/img/validation-report-preview.svg)

## Documentation

- [Quick Start](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/user-guide/quick-start)
- [Validate One CSV](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/user-guide/validate-a-csv)
- [Validate a Folder](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/user-guide/validate-a-folder)
- [Spreadsheet Reports](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/user-guide/spreadsheet-reports)
- [CLI Options](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/reference/cli)
- [Validation Engines](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/how-it-works/validation-engines)
- [Troubleshooting](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/troubleshooting/common-issues)

## Scope

This project validates CSV structure and scalar values against DDL-derived rules. It complements database-level OMOP data-quality tools; it does not replace terminology, clinical, or post-load quality review.

## Development

Install the repository dependencies and run `prove -l t/`. Contribution and implementation details are maintained in the [documentation](https://cnag-biomedical-informatics.github.io/omop-csv-validator/).

## Citation and license

Citation metadata is available in [CITATION.cff](CITATION.cff). The project is released under the [Artistic License 2.0](LICENSE).
