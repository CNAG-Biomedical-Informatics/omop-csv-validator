# Docs Site

This directory contains the local documentation site for `omop-csv-validator`.

## Run locally

This site requires Node.js `20+`.

Install the docs dependencies:

```bash
cd docs-site
npm ci
```

Start the local docs server:

```bash
npm start
```

If port `3000` is already in use, run:

```bash
npm start -- --port 3001
```

Create a production build:

```bash
npm run build
```

## GitHub Pages

This repository now includes a GitHub Actions workflow at `.github/workflows/documentation.yml`.

It:

- installs the docs dependencies in `docs-site`
- runs `npm run build`
- deploys `docs-site/build` to GitHub Pages

The workflow runs on:

- pushes to `main`
- manual dispatch

Before using it, enable GitHub Pages in the repository settings and set the source to **GitHub Actions**.
