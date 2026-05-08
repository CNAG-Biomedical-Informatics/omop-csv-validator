---
sidebar_position: 1
---

# Installation

## Install from CPAN

If you want the packaged release, install it directly from CPAN:

```bash
cpanm -n OMOP::CSV::Validator
```

This is the simplest path if you only want to use the validator.

## Install from Git

Use the repository checkout if you want the latest development version, the docs site, or the full test suite.

This project uses `cpanm` and the repository `cpanfile`.

Install `cpanm` if it is not already available:

```bash
sudo apt-get install cpanminus
```

If your system is missing standard build tooling, install that first:

```bash
sudo apt-get install gcc make libperl-dev
```

Clone the repository and install its dependencies:

```bash
git clone https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator.git
cd omop-csv-validator
cpanm -n --installdeps .
```

If you prefer a local Perl library, configure `local::lib` first:

```bash
cpanm --local-lib=~/perl5 local::lib
eval "$(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)"
```

## Validate the install

If you installed from a repository checkout, run the bundled test suite:

```bash
prove -l t/
```

Print the CLI version:

```bash
omop-csv-validator --version
```

If you are running from a repository checkout without installing the CLI into your `PATH`, use:

```bash
bin/omop-csv-validator --version
```
