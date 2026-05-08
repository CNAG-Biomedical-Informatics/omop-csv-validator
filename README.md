<p align="center">
  <a href="https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator"><img src="https://raw.githubusercontent.com/CNAG-Biomedical-Informatics/omop-csv-validator/main/docs-site/static/img/omop-csv-validator-logo.png" width="300" alt="OMOP CSV Validator"></a>
</p>
<p align="center">
  <em>Validate OMOP CDM CSV files against schemas derived from PostgreSQL DDL</em>
</p>

[![CPAN Publish](https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator/actions/workflows/cpan-publish.yml/badge.svg)](https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator/actions/workflows/cpan-publish.yml)
[![Documentation Status](https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator/actions/workflows/documentation.yml/badge.svg)](https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator/actions/workflows/documentation.yml)
[![Coverage Status](https://coveralls.io/repos/github/CNAG-Biomedical-Informatics/omop-csv-validator/badge.svg?branch=main)](https://coveralls.io/github/CNAG-Biomedical-Informatics/omop-csv-validator?branch=main)
[![Kwalitee Score](https://cpants.cpanauthors.org/dist/OMOP-CSV-Validator.svg)](https://cpants.cpanauthors.org/dist/OMOP-CSV-Validator)
![version](https://img.shields.io/badge/version-0.04[0m-blue)
[![License](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)

---

**📘 Documentation:** <a href="https://cnag-biomedical-informatics.github.io/omop-csv-validator/" target="_blank">https://cnag-biomedical-informatics.github.io/omop-csv-validator/</a>

**📦 CPAN Distribution:** <a href="https://metacpan.org/pod/OMOP::CSV::Validator" target="_blank">https://metacpan.org/pod/OMOP::CSV::Validator</a>

---

# OMOP CSV Validator

OMOP CSV Validator is a small Perl CLI and module for validating OMOP CDM CSV files against schemas derived from PostgreSQL DDL.

## Documentation

Full project documentation lives in the Docusaurus site under [docs-site](docs-site/README.md).

- [Docs overview](docs-site/docs/overview.md)
- [Installation](docs-site/docs/user-guide/installation.md)
- [Validate a CSV](docs-site/docs/user-guide/validate-a-csv.md)
- [CLI reference](docs-site/docs/reference/cli.md)
- [Implementation](docs-site/docs/implementation/overview.md)
- [Troubleshooting](docs-site/docs/troubleshooting/common-issues.md)

## Quick start

Install dependencies and run the validator:

```bash
cpanm -n --installdeps .
bin/omop-csv-validator \
  --ddl ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input example/DRUG_EXPOSURE.csv
```

## Tests

Run the test suite:

```bash
prove -l t/
```

## License

Released under the [Artistic License 2.0](LICENSE).
