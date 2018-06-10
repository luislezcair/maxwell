const { join } = require('path');
const { config } = require('@rails/webpacker');

module.exports = {
  test: /browserconfig\.xml$/,
  use: [
    {
      loader: 'file-loader',
      options: {
        name: '[path][name]-[hash].[ext]',
        context: join(config.source_path),
      },
    },
    {
      loader: 'web-app-browserconfig-loader',
    },
  ],
};
