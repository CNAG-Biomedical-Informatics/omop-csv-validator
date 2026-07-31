---
sidebar_position: 1
---

# Installation

OMOP CSV Validator is used as a command-line program; using it does not require writing or understanding Perl.

| Route | Use it when |
| --- | --- |
| CPAN | Perl is already available and you want the smallest installation |
| Docker or Apptainer | You do not want Perl modules or compiler tools installed on the host |
| Repository checkout | You are developing or testing the project itself |

## Install from CPAN

:::note[Native dependencies]

Some dependencies contain C extensions. CPAN builds these automatically, but a C compiler and development headers must already be installed. Installing under `~/perl5` does not require administrator rights; if the build tools are missing and you cannot install system packages, use the container option below.

:::

### Install under `~/perl5`

This keeps OMOP CSV Validator and its Perl modules in your home directory and does not modify the system Perl. This route uses `cpanm`.

If `cpanm` is not yet available, install it on Debian or Ubuntu:

```bash
sudo apt-get install cpanminus
```

Without `sudo`, install it into your user-configured Perl environment:

```bash
curl -L https://cpanmin.us | perl - App::cpanminus
```

Create the local Perl library, activate it in the current shell, and install the validator:

```bash
cpanm --local-lib=~/perl5 local::lib
eval "$(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)"
cpanm -n OMOP::CSV::Validator
omop-csv-validator --version
```

Make the local library available in future Bash sessions:

```bash
echo 'eval "$(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)"' >> ~/.bashrc
```

### Use the standard CPAN client

The standard CPAN client is included with Perl:

```bash
cpan OMOP::CSV::Validator
omop-csv-validator --version
```

<details>
<summary>If CPAN reports missing build tools on Debian or Ubuntu</summary>

Install the standard compiler and Perl development files, then repeat the CPAN command:

```bash
sudo apt-get install build-essential libperl-dev
```

</details>

## Container alternative

The published image contains release `0.05` and all of its runtime dependencies. It supports Linux `amd64` and `arm64`.

### Docker

Pull the versioned image and check the installed command:

```bash
docker pull manuelrueda/omop-csv-validator:0.05
docker run --rm manuelrueda/omop-csv-validator:0.05 --version
```

Mount the current directory as `/data` when validating local files:

```bash
docker run --rm \
  --volume "$PWD:/data" \
  manuelrueda/omop-csv-validator:0.05 \
  --ddl /data/ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input /data/PERSON.csv
```

Both the DDL and CSV must be inside the mounted directory. Report paths should also use `/data/...` so generated files are written back to the host.

### Apptainer

Apptainer can run the same Docker Hub image without installing Perl on the host:

```bash
apptainer exec \
  docker://manuelrueda/omop-csv-validator:0.05 \
  omop-csv-validator --version
```

Validate files from the current directory with an explicit bind mount:

```bash
apptainer exec \
  --bind "$PWD:/data" \
  docker://manuelrueda/omop-csv-validator:0.05 \
  omop-csv-validator \
  --ddl /data/ddl/OMOPCDM_postgresql_5.4_ddl.sql \
  --input /data/PERSON.csv
```

## Development installation

Use a repository checkout when changing the code, running the test suite, or reading the development files.

Install the required tools on Debian or Ubuntu:

```bash
sudo apt-get install cpanminus build-essential libperl-dev
```

Clone the repository and install its dependencies:

```bash
git clone https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator.git
cd omop-csv-validator
cpanm -n --installdeps .
prove -l t/
```

The checkout command is available at:

```bash
bin/omop-csv-validator --version
```
