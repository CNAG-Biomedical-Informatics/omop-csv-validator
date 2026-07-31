---
sidebar_position: 4
---

# Use from Python

Python integration means calling the same CLI with `--json` and parsing the result with the standard `json` module.

Use this page when a Python script, notebook, or pipeline needs to make decisions from the validation result.

## Why this is the recommended path

- no Perl-to-Python bridge is required
- the validator keeps one stable machine-readable output format
- the same command works in scripts, notebooks, and pipelines

## Minimal example

```python
import json
import subprocess

completed = subprocess.run(
    [
        "bin/omop-csv-validator",
        "--ddl", "ddl/OMOPCDM_postgresql_5.4_ddl.sql",
        "--input", "example/DRUG_EXPOSURE.csv",
        "--json",
    ],
    capture_output=True,
    text=True,
    check=False,
)

result = json.loads(completed.stdout)
result
```

## What you get back

The JSON result contains:

- `input_file`
- `schema_name`
- `ok`
- `error_count`
- `row_errors`

If validation cannot even start, such as when no schema can be inferred, the result also contains `fatal_error`.

These fields are intended to be the stable automation interface for Python clients.

## Typical Python branching

```python
if result["ok"]:
    print("CSV validated successfully")
elif "fatal_error" in result and result["fatal_error"] is not None:
    raise RuntimeError(result["fatal_error"])
else:
    print(result["row_errors"])
```

## Batch validation in Python

For multiple OMOP CSV files, loop over files and run the validator once per file.

```python
import glob
import json
import subprocess

results = []

for csv_file in glob.glob("exports/*.csv"):
    completed = subprocess.run(
        [
            "bin/omop-csv-validator",
            "--ddl", "ddl/OMOPCDM_postgresql_5.4_ddl.sql",
            "--input", csv_file,
            "--json",
        ],
        capture_output=True,
        text=True,
        check=False,
    )

    results.append(json.loads(completed.stdout))
```

That pattern keeps the validator simple while giving Python users a straightforward batch workflow.

:::warning Separator override is usually unnecessary
The CLI normally infers the separator. Add `--sep` in Python only if you know the file needs an explicit override.
:::

## Row numbering

Row numbers in `row_errors` are data rows, not physical line numbers including the header. The first row after the header is row `1`.
