// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Javacript modules //
import $ from 'jquery';
import 'popper.js';
import 'bootstrap';
import '@coreui/coreui';
import 'inputmask';
import 'jstree';

// SASS stylesheets modules //
import '@coreui/coreui/scss/coreui.scss';
import 'font-awesome/scss/font-awesome.scss';
import 'simple-line-icons/scss/simple-line-icons.scss';
import 'jstree/dist/themes/default/style.min.css';

import Turbolinks from 'turbolinks';
import Rails from 'rails-ujs';

import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

// Custom modules
import '../views';

// Custom assets modules //
import '../images';

import '../stylesheets/application.scss';

Turbolinks.start();
Rails.start();

// Stimulus setup
const application = Application.start();
const context = require.context('../controllers', true, /\.js$/);
application.load(definitionsFromContext(context));

document.addEventListener('turbolinks:load', () => {
  $('[data-toggle="tooltip"]').tooltip();

  // Crear y disparar un evento para el controlador y la acción actual
  const body = document.querySelector('body');
  const { action, controller } = body.dataset;
  const loadEvent = new Event(`${controller}:${action}:load`);
  document.dispatchEvent(loadEvent);
});

// Ocultamos los tooltips porque al navegar atrás persisten en la página
document.addEventListener('turbolinks:before-cache', () => {
  $('[data-toggle="tooltip"]').tooltip('hide');
});

// Este evento se dispara cuando se termina de cargar una página de una tabla
// de datos con Kaminari y rails-ujs.
document.addEventListener('maxwell:page_load', (e) => {
  Turbolinks
    .controller
    .pushHistoryWithLocationAndRestorationIdentifier(e.detail.url, Turbolinks.uuid());

  $('[data-toggle="tooltip"]').tooltip();
});
