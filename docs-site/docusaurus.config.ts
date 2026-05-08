import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'OMOP CSV Validator Docs',
  tagline: 'Focused documentation for validating OMOP CSV extracts against DDL-derived schemas',
  favicon: 'img/omop-csv-validator-logo.png',
  url: 'https://cnag-biomedical-informatics.github.io',
  baseUrl: '/omop-csv-validator/',
  organizationName: 'CNAG-Biomedical-Informatics',
  projectName: 'omop-csv-validator',
  onBrokenLinks: 'throw',
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },
  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],
  themeConfig: {
    image: 'img/omop-csv-validator-logo.png',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'OMOP CSV Validator Docs',
      logo: {
        alt: 'OMOP CSV Validator Docs',
        src: 'img/omop-csv-validator-logo.png',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docsSidebar',
          position: 'left',
          label: 'Docs',
        },
        {
          href: 'https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Overview',
              to: '/docs/overview',
            },
          ],
        },
        {
          title: 'Project',
          items: [
            {
              label: 'Repository',
              href: 'https://github.com/CNAG-Biomedical-Informatics/omop-csv-validator',
            },
            {
              label: 'CPAN',
              href: 'https://metacpan.org/pod/OMOP::CSV::Validator',
            },
          ],
        },
      ],
      copyright: 'Copyright © 2025-2026 OMOP CSV Validator.',
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
