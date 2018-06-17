import MaskElementByClass from '../util';

function maskTechnicalServiceFormElements() {
  MaskElementByClass('mask-numeric', 'integer');
  MaskElementByClass('mask-meters', 'meters');
  MaskElementByClass('mask-time', 'shortTime');
  MaskElementByClass('mask-money', 'currency');
}

document.addEventListener('technical_services:new:load', maskTechnicalServiceFormElements);
document.addEventListener('technical_services:edit:load', maskTechnicalServiceFormElements);
