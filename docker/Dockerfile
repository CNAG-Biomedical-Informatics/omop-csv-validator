FROM perl:5.40-slim-bookworm AS builder

ARG OMOP_CSV_VALIDATOR_VERSION=0.05

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       build-essential ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://cpanmin.us | perl - App::cpanminus

# Keep the application and all CPAN dependencies outside the base Perl tree so
# the runtime stage only needs one copied directory.
RUN cpanm --notest --configure-timeout 300 \
    --local-lib-contained /opt/omop-csv-validator \
    "OMOP::CSV::Validator@${OMOP_CSV_VALIDATOR_VERSION}"

RUN PATH="/opt/omop-csv-validator/bin:${PATH}" \
    PERL5LIB="/opt/omop-csv-validator/lib/perl5" \
    omop-csv-validator --version

FROM perl:5.40-slim-bookworm

ARG OMOP_CSV_VALIDATOR_VERSION=0.05
ARG VCS_REF=unknown

LABEL maintainer="Manuel Rueda <manuel.rueda@cnag.eu>" \
      org.opencontainers.image.title="OMOP CSV Validator" \
      org.opencontainers.image.description="Validate OMOP CDM CSV files before database ingestion" \
      org.opencontainers.image.source="https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator" \
      org.opencontainers.image.version="${OMOP_CSV_VALIDATOR_VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.licenses="Artistic-2.0"

COPY --from=builder /opt/omop-csv-validator /opt/omop-csv-validator

ENV PATH="/opt/omop-csv-validator/bin:${PATH}" \
    PERL5LIB="/opt/omop-csv-validator/lib/perl5" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8"

WORKDIR /data

ENTRYPOINT ["omop-csv-validator"]
CMD ["--version"]
