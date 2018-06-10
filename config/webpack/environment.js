const { environment } = require('@rails/webpacker');
const webmanifest = require('./loaders/webmanifest');
const browserconfig = require('./loaders/browserconfig');

environment.loaders.insert('webmanifest', webmanifest, { before: 'file' });
environment.loaders.insert('browserconfig', browserconfig, { before: 'file' });

module.exports = environment;
