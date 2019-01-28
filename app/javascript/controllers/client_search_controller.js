/* eslint no-underscore-dangle: 0 */

import $ from 'jquery';
import { Controller } from 'stimulus';

import 'jquery-ui/themes/base/core.css';
import 'jquery-ui/themes/base/menu.css';
import 'jquery-ui/themes/base/theme.css';
import 'jquery-ui/themes/base/autocomplete.css';
import 'jquery-ui/ui/widgets/autocomplete';

export default class extends Controller {
  static targets = ['valueInput', 'idInput', 'citySelect', 'planServiceSelect'];

  connect() {
    const element = $(this.valueInputTarget);

    // Configurar autocomplete en el input. Al seleccionar un valor, cambia el
    // idInput al ID del cliente seleccionado.
    element.autocomplete({
      source: this.data.get('url'),
      minLength: 1,
      select: (_event, ui) => {
        this.idInputTarget.value = ui.item.id;

        // Cuando se usa el campo cliente en los formularios de búsqueda, estos
        // targets pueden no existir
        if (this.hasCitySelectTarget) {
          this.citySelectTarget.value = ui.item.city_id;
        }

        if (this.hasPlanServiceSelectTarget) {
          this.planServiceSelectTarget.value = ui.item.plan_service_id;
        }
      },
    });

    // Redefinimos la función renderItem para resaltar el término de búsqueda
    // en la lista de resultados.
    element.data('ui-autocomplete')._renderItem = (ul, item) => {
      // Interpretar espacios como separación entre nombre y apellido. Hacer
      // match con cualquier caracter para casos como "karg, luis" (match en
      // coma y espacio).
      const pattern = this.valueInputTarget.value.replace(' ', '.?.?');

      const newText = String(item.value).replace(
        new RegExp(pattern, 'gi'),
        '<span class="ui-state-highlight">$&</span>',
      );

      return $('<li></li>')
        .data('ui-autocomplete-item', item)
        .append(`<div>${newText}</div>`)
        .appendTo(ul);
    };

    // Seleccionar el input al hacer click
    this.valueInputTarget.onclick = () => {
      this.valueInputTarget.select();
    };

    // Cuando se borra todo el contenido del input, borrar también el idInput
    this.valueInputTarget.oninput = () => {
      if (this.valueInputTarget.value.length === 0) {
        this.idInputTarget.value = '';
      }
    };
  }

  /**
   * Evento cuando se hace click en el botón "limpiar"
   */
  reset() {
    this.valueInputTarget.value = '';
    this.idInputTarget.value = '';
  }
}
