import Rails from 'rails-ujs';
import $ from 'jquery';
import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['input', 'button'];

  // Evento cuando se hace click en Buscar cliente
  show() {
    const url = this.data.get('url');

    Rails.ajax({
      type: 'GET',
      dataType: 'script',
      url,
      success: () => {
        $('#client-search-modal').modal('show');
      },
    });
  }

  // Evento cuando cambia el input de búsqueda
  change() {
    this.buttonTarget.disabled = this.inputTarget.value.length < 3
  }

  // Evento cuando se selecciona un cliente de la tabla
  select() {
    const id = this.data.get('id');
    const label = this.data.get('label');
    document.getElementById('technical_service_client').value = label;
    document.getElementById('technical_service_client_id').value = id;
    $('#client-search-modal').modal('hide');
  }
}
