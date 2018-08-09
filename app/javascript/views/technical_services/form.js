import { MaskElementByClass, MakeDateRangePicker } from '../util';

function maskTechnicalServiceFormElements() {
  MakeDateRangePicker('.input-group.date');

  MaskElementByClass('mask-numeric', 'integer');
  MaskElementByClass('mask-meters', 'meters');
  MaskElementByClass('mask-time', 'shortTime');
  MaskElementByClass('mask-date', 'date');
  MaskElementByClass('mask-money', 'currency');
}

document.addEventListener('technical_services:new:load', maskTechnicalServiceFormElements);
document.addEventListener('technical_services:edit:load', maskTechnicalServiceFormElements);
