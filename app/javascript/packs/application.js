// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Javacript modules //
import $ from 'jquery';
import 'popper.js';
import 'bootstrap';
import '@coreui/coreui';

// SASS stylesheets modules //
import '@coreui/coreui/scss/coreui.scss';
import 'font-awesome/scss/font-awesome.scss';
import 'simple-line-icons/scss/simple-line-icons.scss';
import 'inputmask';

// import WebpackerReact from 'webpacker-react';
import Turbolinks from 'turbolinks';
import Rails from 'rails-ujs';
// import ReactTest from '../components/ReactTest';

// Custom modules
import '../views';

// Custom assets modules //
import '../images';

import '../stylesheets/application.scss';

Turbolinks.start();
Rails.start();

// WebpackerReact.setup({ ReactTest });

document.addEventListener('turbolinks:load', () => {
  $('.sidebar').sidebar();
  $('.aside-menu')['aside-menu']();

  // Crear y disparar un evento para el controlador y la acción actual
  const body = document.querySelector('body');
  const { action, controller } = body.dataset;
  const loadEvent = new Event(`${controller}:${action}:load`);
  document.dispatchEvent(loadEvent);
});
