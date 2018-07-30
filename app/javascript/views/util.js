import Inputmask from 'inputmask';

const maskDefaults = {
  integer: { alias: 'integer' },
  meters: {
    alias: 'numeric',
    radixPoint: ',',
    digits: 2,
    suffix: ' m',
    removeMaskOnSubmit: true,
    unmaskAsNumber: true,
  },
  shortTime: { alias: 'datetime', inputFormat: 'HH:MM' },
  currency: {
    alias: 'currency',
    prefix: '',
    groupSeparator: '.',
    radixPoint: ',',
    removeMaskOnSubmit: true,
    unmaskAsNumber: true,
  },
  date: { alias: 'datetime', inputFormat: 'dd/mm/yyyy' },
  phone: {
    mask: '(9999) 999 999',
    removeMaskOnSubmit: true,
    unmaskAsNumber: true,
  },
};

const MaskElementByClass = (selector, mask) => {
  const elements = document.getElementsByClassName(selector);
  const m = new Inputmask(maskDefaults[mask]);
  m.mask(elements);
};

export default MaskElementByClass;
