# Examples

`DRUG_EXPOSURE.csv` is a valid four-row OMOP table export extracted from [Eunomia](https://ohdsi.github.io/Eunomia/).

`invalid/PERSON.csv` is a small demonstration fixture. Its first row is valid; its second row deliberately uses `A17` for the integer `person_id` field so that the CLI, JSON, TSV, and XLSX failure outputs can be reproduced.
