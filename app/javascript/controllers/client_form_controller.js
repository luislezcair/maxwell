import $ from 'jquery';
import { Controller } from 'stimulus';
import { MaskElementByClass, MaskElement, MakeDateRangePicker } from '../views/util';

export default class extends Controller {
  static targets = ['inputType', 'personFieldset', 'companyFieldset', 'docType',
    'docNumber'];

  connect() {
    if (this.inputTypeTarget.value === 'company') {
      $(this.personFieldsetTarget).hide();
    } else {
      $(this.companyFieldsetTarget).hide();
    }

    MaskElementByClass('mask-phone', 'phone');
    MaskElement(this.docNumberTarget, this.docTypeTarget.value);

    MakeDateRangePicker('.input-group.date');
    MaskElementByClass('mask-date', 'date');
  }

  changeType() {
    $(this.personFieldsetTarget).slideToggle();
    $(this.companyFieldsetTarget).slideToggle();
  }

  /**
   * Evento llamos al seleccionar un tipo de documento. Al cambiar entre CUIT y
   * DNI mantenemos los valores para no perderlos al aplicar la máscara.
   */
  docTypeChange() {
    const oldValue = this.docNumberTarget.inputmask.unmaskedvalue();

    MaskElement(this.docNumberTarget, this.docTypeTarget.value);

    // Si pasamos de CUIT a DNI ponemos como valor la parte del DNI de un CUIT.
    if (this.docTypeTarget.value === 'dni') {
      this.docNumberTarget.value = oldValue.slice(2, 10);
    } else if (oldValue.length > 0) {
      this.docNumberTarget.value = `00${oldValue}0`;
    }
  }
}
