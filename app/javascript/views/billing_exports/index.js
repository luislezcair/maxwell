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

    $('#btn-export').prop('disabled', !state);
  });

  $('#check-all').change();
}

function disablePerformButton() {
  $('#btn-perform').addClass('disabled');
  $('#btn-perform span').text('Enviando...');
  $('#job-status-container .flexible').fadeIn();
}

function performFinished() {
  $('#job-status-container i.fa').replaceWith('<i class="fa fa-check fa-2x"></i>');
}

function performBillingExport({ detail: { id } }) {
  Rails.ajax({
    type: 'GET',
    dataType: 'script',
    url: `/billing_exports/${id}/job_status`,
  });
}

document.addEventListener('billing_exports:index:load', maskSearchFormElements);
document.addEventListener('billing_exports:index:load', setupCheckboxes);

// Evento que se dispara al obtener la respuesta de Enviar a Facturación:
document.addEventListener('billing_exports:perform_disable', disablePerformButton);
document.addEventListener('billing_exports:perform_loop', performBillingExport);
document.addEventListener('billing_exports:perform_finished', performFinished);
