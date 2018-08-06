import Rails from 'rails-ujs';
import $ from 'jquery';
import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['status', 'statusText', 'statusIcon', 'actions', 'button'];

  // Consulta el estado del trabajo en la URL job_status
  getJobStatus(url) {
    Rails.ajax({
      type: 'GET',
      dataType: 'json',
      url,
      success: (job) => {
        this.handleJobUpdates(job, url);
      },
    });
  }

  // Se encarga de actualizar los elementos visuales para indicar el estado del
  // proceso: texto, ícono y estado de los botonos. Mantiene activo el polling.
  handleJobUpdates(job, url) {
    this.statusTextTarget.textContent = job.statusText;
    $(this.statusTarget).fadeIn();

    if (!(job.error || job.finished)) {
      setTimeout(() => {
        this.getJobStatus(url);
      }, 500);
    } else if (job.finished) {
      this.statusIconTarget.className = 'fa fa-check fa-2x';
      this.actionsTarget.innerHTML = job.actionsHtml;
    } else if (job.error) {
      this.statusIconTarget.className = 'fa fa-times fa-2x';
      this.statusTextTarget.textContent = job.errorMsg;
      this.buttonTarget.classList.remove('disabled');
    }
  }

  // Evento cuando se hace click en Enviar a facturación un comprobante
  // individual. Enviamos un POST a perform_sync para comenzar el proceso.
  // PerformSync devuelve una URL para consultar el estado del proceso en un
  // polling.
  start(e) {
    this.buttonTarget.classList.add('disabled');
    e.preventDefault();

    Rails.ajax({
      type: 'POST',
      dataType: 'json',
      url: this.buttonTarget.href,
      success: (r) => {
        this.getJobStatus(r.status_url);
      },
    });
  }
}
