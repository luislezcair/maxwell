import { MaskElementByClass } from '../util';

function maskPhoneElement() {
  MaskElementByClass('mask-phone', 'phone');
}

document.addEventListener('corporate_cellphones:new:load', maskPhoneElement);
document.addEventListener('corporate_cellphones:edit:load', maskPhoneElement);
