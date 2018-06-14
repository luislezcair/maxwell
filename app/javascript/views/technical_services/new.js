import MaskElementByClass from '../util';

document.addEventListener('technical_services:new:load', () => {
  MaskElementByClass('mask-numeric', 'integer');
  MaskElementByClass('mask-meters', 'meters');
  MaskElementByClass('mask-time', 'shortTime');
  MaskElementByClass('mask-money', 'currency');
});
