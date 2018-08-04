import $ from 'jquery';
import 'bootstrap-datepicker';
import 'bootstrap-datepicker/js/locales/bootstrap-datepicker.es';
import 'bootstrap-datepicker/dist/css/bootstrap-datepicker3.css';
import MaskElementByClass from '../util';

function maskSearchFormElements() {
  $('.input-group.input-daterange').datepicker({
    todayBtn: 'linked',
    language: 'es',
    autoclose: true,
  });
  MaskElementByClass('mask-date', 'date');
}

document.addEventListener('technical_services:index:load', maskSearchFormElements);
