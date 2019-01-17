/* eslint no-underscore-dangle: 0 */

import $ from 'jquery';
import { Controller } from 'stimulus';

import 'jquery-ui/themes/base/core.css';
import 'jquery-ui/themes/base/menu.css';
import 'jquery-ui/themes/base/theme.css';
import 'jquery-ui/themes/base/autocomplete.css';
import 'jquery-ui/ui/widgets/autocomplete';

export default class extends Controller {
  static targets = ['valueInput', 'idInput'];

  connect() {
    const element = $(this.valueInputTarget);

    // Configurar autocomplete en el input. Al seleccionar un valor, cambia el
    // idInput al ID del cliente seleccionado.
    element.autocomplete({
      source: this.data.get('url'),
      minLength: 3,
      select: (_event, ui) => {
        this.idInputTarget.value = ui.item.id;
      },
    });

    // Redefinimos la función renderItem para resaltar el término de búsqueda
    // en la lista de resultados.
    element.data('ui-autocomplete')._renderItem = (ul, item) => {
      const newText = String(item.value).replace(
        new RegExp(this.valueInputTarget.value, 'gi'),
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
