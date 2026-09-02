import Link from '@docusaurus/Link';
import Layout from '@theme/Layout';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './index.module.css';

const guideLinks = [
  {
    label: 'First run',
    title: 'Quick start',
    text: 'Run bundled valid and failing examples and inspect the real results.',
    to: '/docs/user-guide/quick-start',
  },
  {
    label: 'Batch',
    title: 'Validate a folder',
    text: 'Use a shell loop or workflow job to run the validator once per CSV file.',
    to: '/docs/user-guide/validate-a-folder',
  },
  {
    label: 'Review',
    title: 'Spreadsheet reports',
    text: 'Create TSV or XLSX reports that show which rows need attention.',
    to: '/docs/user-guide/spreadsheet-reports',
  },
  {
    label: 'Automation',
    title: 'Use JSON output',
    text: 'Call the same CLI from R, Python, notebooks, or workflow jobs.',
    to: '/docs/user-guide/validate-a-csv#use-json-for-automation',
  },
];

export default function Home() {
  const reportUrl = useBaseUrl('/img/validation-report-preview.svg');

  return (
    <Layout
      title="OMOP CSV Validator"
      description="Validate OMOP CDM CSV exports before database ingestion">
      <main className={styles.page}>
        <section className={styles.hero}>
          <div className={styles.heroInner}>
            <div className={styles.copy}>
              <p className={styles.kicker}>Pre-ingestion OMOP checks</p>
              <h1>OMOP CSV Validator</h1>
              <p className={styles.value}>
                Validate OMOP CDM CSV files before database ingestion.
              </p>
              <p className={styles.lede}>
                Each run checks one CSV file for one OMOP table against OMOP PostgreSQL
                DDL. Run it during ETL development, before loading the file into
                PostgreSQL.
              </p>
              <div className={styles.actions}>
                <Link className={styles.actionPrimary} to="/docs/user-guide/validate-a-csv">
                  Validate a CSV
                </Link>
                <Link className={styles.action} to="/docs/user-guide/spreadsheet-reports">
                  Review reports
                </Link>
                <Link className={styles.action} to="/docs/overview">
                  Read docs
                </Link>
              </div>
            </div>

            <div className={styles.runPreview} aria-label="Example OMOP CSV validation result">
              <div className={styles.previewTitle}>Example validation run</div>
              <pre><code><span>$</span>{' omop-csv-validator \\'}<br />
{'  --ddl OMOPCDM.sql \\'}<br />
{'  --input PERSON.csv'}<br />
<strong>OK</strong>{' PERSON.csv is valid'}<br />
<br />
<span>$</span>{' omop-csv-validator \\'}<br />
{'  --ddl OMOPCDM.sql \\'}<br />
{'  --input DRUG_EXPOSURE.csv'}<br />
<em>ERROR</em>{' 1 row failed validation'}</code></pre>
              <div className={styles.statuses}>
                <div><span>Valid files</span><strong>exit 0</strong></div>
                <div><span>Invalid files</span><strong>exit 1</strong></div>
                <div><span>Reports</span><strong>optional</strong></div>
              </div>
            </div>
          </div>
        </section>

        <section className={styles.resultSection}>
          <div className={styles.resultInner}>
            <div className={styles.sectionHeading}>
              <div>
                <p className={styles.sectionLabel}>Validation output</p>
                <h2>Terminal, JSON, TSV, and XLSX output</h2>
              </div>
              <p>
                The exit code and terminal output report the result. Optional TSV and
                XLSX files include one status per row.
              </p>
            </div>
            <img
              className={styles.resultImage}
              src={reportUrl}
              alt="OMOP CSV Validator command-line and spreadsheet result preview"
            />
          </div>
        </section>

        <section className={styles.sections} aria-label="Documentation sections">
          <div className={styles.grid}>
            {guideLinks.map((guide) => (
              <Link className={styles.card} to={guide.to} key={guide.title}>
                <span>{guide.label}</span>
                <h2>{guide.title}</h2>
                <p>{guide.text}</p>
              </Link>
            ))}
          </div>
        </section>
      </main>
    </Layout>
  );
}
