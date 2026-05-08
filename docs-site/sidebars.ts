import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  docsSidebar: [
    'overview',
    {
      type: 'category',
      label: 'User Guide',
      items: [
        'user-guide/installation',
        'user-guide/validate-a-csv',
        'user-guide/spreadsheet-reports',
        'user-guide/use-from-r',
        'user-guide/use-from-python',
        'user-guide/worked-example',
      ],
    },
    {
      type: 'category',
      label: 'Reference',
      items: [
        'reference/cli',
        'reference/module-api',
        'reference/utilities',
      ],
    },
    {
      type: 'category',
      label: 'Implementation',
      items: [
        'implementation/overview',
        'implementation/benchmark',
      ],
    },
    {
      type: 'category',
      label: 'Troubleshooting',
      items: ['troubleshooting/common-issues'],
    },
  ],
};

export default sidebars;
