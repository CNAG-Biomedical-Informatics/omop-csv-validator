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

**📘 Documentation:** <a href="https://cnag-biomedical-informatics.github.io/omop-csv-validator/" target="_blank">https://cnag-biomedical-informatics.github.io/omop-csv-validator/</a>

**📦 CPAN Distribution:** <a href="https://metacpan.org/pod/OMOP::CSV::Validator" target="_blank">https://metacpan.org/pod/OMOP::CSV::Validator</a>

**🐳 Docker Hub Image:** <a href="https://hub.docker.com/r/manuelrueda/omop-csv-validator/tags" target="_blank">https://hub.docker.com/r/manuelrueda/omop-csv-validator/tags</a>

## Quick start

Install the release from CPAN:

```bash
cpan OMOP::CSV::Validator
```

```bash
omop-csv-validator \
  --ddl path/to/OMOPCDM_postgresql_5.4_ddl.sql \
  --input path/to/DRUG_EXPOSURE.csv
```

```text
✅ CSV file 'path/to/DRUG_EXPOSURE.csv' is valid against the 'DRUG_EXPOSURE' schema.
```

Each invocation validates one CSV file against one OMOP table. See [Installation](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/user-guide/installation) for the recommended user-local setup and the Docker or Apptainer alternative; see the [Quick Start](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/user-guide/quick-start) for runnable valid and invalid examples.

![Command-line and spreadsheet validation results](https://raw.githubusercontent.com/CNAG-Biomedical-Informatics/omop-csv-validator/main/docs-site/static/img/validation-report-preview.svg)

## Scope

This project validates CSV structure and scalar values against DDL-derived rules. It complements database-level OMOP data-quality tools; it does not replace terminology, clinical, or post-load quality review.

## Development

Use the [development installation](https://cnag-biomedical-informatics.github.io/omop-csv-validator/docs/user-guide/installation#development-installation) and run `prove -l t/`.

## Citation and license

Citation metadata is available in [CITATION.cff](CITATION.cff). The project is released under the [Artistic License 2.0](LICENSE).
