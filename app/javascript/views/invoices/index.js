import { MaskElementByClass, MakeDateRangePicker } from '../util';

function maskSearchFormElements() {
  MakeDateRangePicker('.input-group.input-daterange');
  MaskElementByClass('mask-date', 'date');
}

document.addEventListener('invoices:index:load', maskSearchFormElements);
