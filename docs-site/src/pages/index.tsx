import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import useBaseUrl from '@docusaurus/useBaseUrl';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';

import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  const logoUrl = useBaseUrl('/img/omop-csv-validator-logo.png');

  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <div className="omop-docs-hero-brand">
          <img
            className="omop-docs-hero-logo"
            src={logoUrl}
            alt="OMOP CSV Validator logo"
          />
          <Heading as="h1" className="hero__title omop-docs-hero-title">
            {siteConfig.title}
          </Heading>
        </div>
        <p className="hero__subtitle">{siteConfig.tagline}</p>
        <div className={styles.buttons}>
          <Link className="button button--primary button--lg" to="/docs/overview">
            Open docs
          </Link>
          <Link className="button button--secondary button--lg" to="/docs/user-guide/validate-a-csv">
            Validate a CSV
          </Link>
        </div>
      </div>
    </header>
  );
}

function FeatureCards() {
  return (
    <section className={styles.featuresSection}>
      <div className="container">
        <div className="row">
          <div className="col col--4">
            <div className="omop-feature-card">
              <Heading as="h3">DDL-driven validation</Heading>
              <p>
                Build validation rules directly from OMOP PostgreSQL DDL instead of manually
                maintaining per-table schemas.
              </p>
            </div>
          </div>
          <div className="col col--4">
            <div className="omop-feature-card">
              <Heading as="h3">Small operational surface</Heading>
              <p>
                This project is a focused CLI plus Perl module, so the docs stay close to the
                real workflows people use.
              </p>
            </div>
          </div>
          <div className="col col--4">
            <div className="omop-feature-card">
              <Heading as="h3">Explicit caveats</Heading>
              <p>
                Known limitations around DDL parsing, null handling, and memory usage are
                documented directly instead of being implied.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();

  return (
    <Layout
      title={siteConfig.title}
      description="Documentation for the OMOP CSV Validator CLI, Perl module, and validation workflows.">
      <HomepageHeader />
      <main>
        <FeatureCards />
      </main>
    </Layout>
  );
}
