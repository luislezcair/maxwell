const { join } = require('path');
const { config } = require('@rails/webpacker');

module.exports = {
  test: /\.webmanifest$/,
  use: [
    {
      loader: 'file-loader',
      options: {
        name: '[path][name]-[hash].[ext]',
        context: join(config.source_path),
      },
    },
    {
      loader: 'webmanifest-loader',
    },
  ],
};
