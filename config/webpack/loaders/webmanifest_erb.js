const { join } = require('path');
const { config } = require('@rails/webpacker');

module.exports = {
  test: /site\.webmanifest\.erb$/,
  enforce: 'pre',
  exclude: /node_modules/,
  use: [
    {
      loader: 'file-loader',
      options: {
        name: '[path]site-[hash].webmanifest',
        context: join(config.source_path),
      },
    },
    {
      loader: 'rails-erb-loader',
      options: {
        runner: (/^win/.test(process.platform) ? 'ruby ' : '') + 'bin/rails runner'
      },
    },
  ],
};

