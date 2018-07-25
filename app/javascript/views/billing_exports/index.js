import $ from 'jquery';
import Rails from 'rails-ujs';
import MaskElementByClass from '../util';

function maskSearchFormElements() {
  MaskElementByClass('mask-date', 'date');
}

// Maneja la selección de servicios técnicos mediante checkboxes.
function setupCheckboxes() {
  $(document).on('change', '.table-checkbox', (e) => {
    const table = $('#billing-exports-table > tbody');
    const checkboxes = table.find('input[type="checkbox"]');
    let state = false;

    // Se hizo click en el checkbox '(de)seleccionar todo'
    if (e.target.id === 'check-all') {
      state = $(e.target).is(':checked');
      checkboxes.prop('checked', state);
      state = state && checkboxes.length > 0;
    } else {
      // Se hizo click en un checkbox de la tabla. Si la cantdad de checkboxes
      // (des)seleccionados es igual al total, (des)activa el checkbox de la cabecera.
      const qty = table.find('input:checked').length;
      $('#check-all').prop('checked', qty === checkboxes.length);
      state = qty > 0;
    }

    $('#btn-save-invoices').prop('disabled', !state);
  });

  $('#check-all').change();
}

function setupEvents() {
  $(document).on('click', '[data-toggle-replace]', (e) => {
    const selector = e.target.dataset.target;
    const html = e.target.dataset.toggleReplace;
    $(selector).html(html);
  });
}

function disablePerformButton() {
  $('#btn-perform').addClass('disabled');
  $('#btn-perform span').text('Enviando...');
  $('#job-status-container .flexible').fadeIn();
}

function performBillingExport({ detail: { url } }) {
  Rails.ajax({
    type: 'GET',
    dataType: 'script',
    url,
  });
}

// Cuando termina una facturación, se dispara este evento. El parámetro `ids`
// contiene un arreglo con los IDs de los servicios técnicos. Usamos estos IDs
// para buscar en la tabla la fila correspondiente y eliminar el checkbox,
// estilizar la file y eliminar las acciones Editar y Eliminar.
function performFinished({ detail: { ids } }) {
  const table = $('#billing-exports-table > tbody');

  ids.forEach((id) => {
    const checkbox = table.find(`input[type="checkbox"][value="${id}"]`);
    const row = checkbox.parents('tr');
    const actionButtons = row.find('td:last-child > a');

    checkbox.remove();
    row.addClass('billing-export-done');
    actionButtons[1].remove();
    actionButtons[2].remove();
  });
}

document.addEventListener('billing_exports:index:load', maskSearchFormElements);
document.addEventListener('billing_exports:index:load', setupCheckboxes);
document.addEventListener('billing_exports:index:load', setupEvents);

// Evento que se dispara al obtener la respuesta de Enviar a Facturación:
document.addEventListener('billing_exports:perform_disable', disablePerformButton);
document.addEventListener('billing_exports:perform_loop', performBillingExport);
document.addEventListener('billing_exports:perform_finished', performFinished);
