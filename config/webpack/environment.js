const { environment } = require('@rails/webpacker');

const xmlErb = require('./loaders/xml_erb');
const webmanifestErb = require('./loaders/webmanifest_erb');
const erb = require('./loaders/erb');

environment.loaders.prepend('xmlErb', xmlErb);
environment.loaders.prepend('webmanifestErb', webmanifestErb);

environment.loaders.append('erb', erb);

module.exports = environment;
