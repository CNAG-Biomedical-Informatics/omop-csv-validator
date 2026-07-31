import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  docsSidebar: [
    {type: 'doc', id: 'overview', label: 'Overview'},
    {
      type: 'category',
      label: 'Getting Started',
      collapsed: false,
      items: [
        'user-guide/installation',
        'user-guide/quick-start',
        'user-guide/validate-a-csv',
        'user-guide/validate-a-folder',
      ],
    },
    {
      type: 'category',
      label: 'Optional Reports & Integrations',
      items: [
        'user-guide/spreadsheet-reports',
        'user-guide/use-from-r',
        'user-guide/use-from-python',
      ],
    },
    {
      type: 'category',
      label: 'Reference',
      items: [
        {type: 'doc', id: 'reference/cli', label: 'CLI Options'},
        {type: 'doc', id: 'reference/module-api', label: 'Perl Module API'},
        {type: 'doc', id: 'reference/csv-reorder-utility', label: 'CSV Reorder Utility'},
      ],
    },
    {
      type: 'category',
      label: 'How It Works',
      items: [
        {type: 'doc', id: 'how-it-works/validation-engines', label: 'Validation Engines'},
        {type: 'doc', id: 'how-it-works/benchmark', label: 'Benchmark'},
      ],
    },
    {type: 'doc', id: 'troubleshooting/common-issues', label: 'Troubleshooting'},
  ],
};

export default sidebars;
