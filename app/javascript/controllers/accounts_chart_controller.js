import Rails from 'rails-ujs';
import $ from 'jquery';
import { Controller } from 'stimulus';
import { MaskElementByClass } from '../views/util';

export default class extends Controller {
  static targets = ['tree', 'edit', 'new', 'delete', 'formModal', 'deleteModal', 'deleteErrorDiv', 'deleteConfirm'];

  connect() {
    // Creamos el árbol de cuentas obtieniendo las cuentas en JSON desde
    // /accounts.json
    $(this.treeTarget).jstree({
      core: {
        multiple: false,
        data: {
          url: this.data.get('url'),
        },
        worker: false,
      },
    });

    // JSTree dispara el evento changed cada vez que se hace click en un nodo
    $(this.treeTarget).on('changed.jstree', (e, data) => {
      this.nodeChanged(data.instance.get_node(data.selected[0]));
    });

    // Cuando se crea una cuenta, el controlador devuelve un JSR que dispara
    // el evento 'accounts:create', lo enlazamos a un método para manejarlo acá
    this.formModalTarget.addEventListener('accounts:create_success', this.createSuccess);
    this.formModalTarget.addEventListener('accounts:create_error', this.createError);

    $(this.deleteModalTarget).on('hidden.bs.modal', this.restoreDeleteModal);
  }

  /**
   * Método llamado cuando el usuario hace click en una cuenta del plan de
   * cuentas. Guarda el nodo seleccionado en los data-attributes de este
   * controlador.
   * @param {Object} node - nodo en el que se hizo click.
   */
  nodeChanged = (node) => {
    if (node) {
      this.editTarget.disabled = false;
      this.deleteTarget.disabled = false;

      const id = node.id.replace('acc_', '');
      this.data.set('node', id);
    } else {
      this.editTarget.disabled = true;
      this.deleteTarget.disabled = true;
    }
  };

  /**
   * Método llamado al hacer click en el botón Editar
   */
  editClick = () => {
    const url = `/accounts/${this.data.get('node')}/edit`;
    this.getFormModal(url);
  };

  /**
   * Método llamado al hacer click en el botón Nuevo
   */
  newClick = () => {
    const nodeId = this.data.get('node');
    let url = this.data.get('newUrl');

    if (nodeId) {
      url += `?parent_id=${nodeId}`;
    }

    this.getFormModal(url);
  };

  /**
   * Utiliza Rails para obtener la URL url en formato JS y luego muestra el
   * formModal. La URL debe devolver el HTML del formulario de cuentas.
   * @param {string} - URL que se va a consultar.
   */
  getFormModal = (url) => {
    Rails.ajax({
      type: 'GET',
      dataType: 'script',
      url,
      success: () => {
        MaskElementByClass('mask-account-code', 'accountCode');
        $(this.formModalTarget).modal('show');
      },
    });
  };

  /**
   * Método llamado desde el JSR de /accounts#create cuando se crea correctamente
   * una cuenta nueva. Esté método oculta el formModal y actualiza el JSTree.
   */
  createSuccess = () => {
    $(this.formModalTarget).modal('hide');
    $(this.treeTarget).jstree('refresh');
  };

  /**
   * Si hay un error en el formulario, el JSR vuelve a renderizar y hay que
   * poner las máscaras nuevamente
   */
  createError = () => {
    MaskElementByClass('mask-account-code', 'accountCode');
  };

  /**
   * Método llamado cuando el usuario hace click en Eliminar cuenta.
   */
  deleteClick = () => {
    $(this.deleteModalTarget).modal('show');
  };

  /**
   * Método llamado cuando el usuario hace click en Confirmar eliminación de
   * cuenta.
   */
  deleteConfirmClick = () => {
    this.deleteConfirmTarget.disabled = true;

    Rails.ajax({
      type: 'DELETE',
      dataType: 'json',
      url: `accounts/${this.data.get('node')}`,
      success: (r) => {
        if (r.result) {
          this.deleteConfirmTarget.disabled = false;
          $(this.deleteModalTarget).modal('hide');
          $(this.treeTarget).jstree('refresh');
        } else {
          this.deleteErrorDivTarget.innerHTML = '<strong>¡Atención!</strong> ' + r.errors.base[0];
          $(this.deleteErrorDivTarget).fadeIn();
        }
      },
    });
  };

  /**
   * Reestablece el estado del modal de Confirmar eliminación. Habilita el botón
   * Eliminar y oculta el mensaje de error.
   */
  restoreDeleteModal = () => {
    this.deleteConfirmTarget.disabled = false;
    $(this.deleteErrorDivTarget).hide();
  };
}
