import Inputmask from 'inputmask';

const maskDefaults = {
  integer: { alias: 'integer' },
  meters: {
    alias: 'numeric',
    radixPoint: ',',
    digits: 2,
    suffix: ' m',
  },
  shortTime: { alias: 'datetime', inputFormat: 'HH:MM' },
  currency: {
    alias: 'currency',
    prefix: '',
    groupSeparator: '.',
    radixPoint: ',',
  },
};

const MaskElementByClass = (selector, mask) => {
  const elements = document.getElementsByClassName(selector);
  const m = new Inputmask(maskDefaults[mask]);
  m.mask(elements);
};

export default MaskElementByClass;
