---
sidebar_position: 3
---

# Use from R

R integration means calling the same CLI with `--json` and parsing the result with `jsonlite`.

Use this page when an R script, notebook, or pipeline needs to make decisions from the validation result.

## Why this is the recommended path

- no Perl-to-R bridge is required
- the validator keeps one stable machine-readable output format
- the same command works in scripts, notebooks, and pipelines

## Minimal example

```r
library(jsonlite)

cmd <- c(
  "--ddl", "ddl/OMOPCDM_postgresql_5.4_ddl.sql",
  "--input", "example/DRUG_EXPOSURE.csv",
  "--json"
)

raw <- system2(
  "bin/omop-csv-validator",
  args = cmd,
  stdout = TRUE,
  stderr = FALSE
)

result <- fromJSON(paste(raw, collapse = "\n"))
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

These fields are intended to be the stable automation interface for R clients.

## Typical R branching

```r
if (isTRUE(result$ok)) {
  message("CSV validated successfully")
} else if (!is.null(result$fatal_error)) {
  stop(result$fatal_error)
} else {
  print(result$row_errors)
}
```

## Batch validation in R

For multiple OMOP CSV files, loop over files and run the validator once per file.

```r
library(jsonlite)

csv_files <- list.files("exports", pattern = "\\.csv$", full.names = TRUE)

results <- lapply(csv_files, function(csv_file) {
  raw <- system2(
    "bin/omop-csv-validator",
    args = c(
      "--ddl", "ddl/OMOPCDM_postgresql_5.4_ddl.sql",
      "--input", csv_file,
      "--json"
    ),
    stdout = TRUE,
    stderr = FALSE
  )

  fromJSON(paste(raw, collapse = "\n"))
})
```

That pattern keeps the validator simple while giving R users a straightforward batch workflow.

:::warning Separator override is usually unnecessary
The CLI normally infers the separator. Add `--sep` in R only if you know the file needs an explicit override.
:::

## Row numbering

Row numbers in `row_errors` are data rows, not physical line numbers including the header. The first row after the header is row `1`.
