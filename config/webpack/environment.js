const { environment } = require('@rails/webpacker');
const webmanifest = require('./loaders/webmanifest');
const browserconfig = require('./loaders/browserconfig');
const webpack = require('webpack');

environment.loaders.insert('webmanifest', webmanifest, { before: 'file' });
environment.loaders.insert('browserconfig', browserconfig, { before: 'file' });

// Esto solo es necesario para bootstrap-datepicker
environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    jQuery: 'jquery',
  }),
);

module.exports = environment;
