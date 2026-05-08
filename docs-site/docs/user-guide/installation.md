---
sidebar_position: 1
---

# Installation

## Perl dependencies

This project uses `cpanm` and the repository `cpanfile`.

Install `cpanm` if it is not already available:

```bash
sudo apt-get install cpanminus
```

If your system is missing standard build tooling, install that first:

```bash
sudo apt-get install gcc make libperl-dev
```

## Local dependency install

Inside the repository:

```bash
cpanm -n --installdeps .
```

If you prefer a local Perl library, configure `local::lib` first:

```bash
cpanm --local-lib=~/perl5 local::lib
eval "$(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)"
```

## Install from CPAN

If you want the packaged release instead of the repository checkout:

```bash
cpanm -n OMOP::CSV::Validator
```

## Validate the install

Run the bundled test suite:

```bash
prove -l t/
```

Print the CLI version:

```bash
bin/omop-csv-validator --version
```
