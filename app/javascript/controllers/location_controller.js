import $ from 'jquery';
import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['input', 'link', 'error'];

  // El atributo perform va a ser true cuando se trate de un nuevo servicio
  // técnico. Si está editando uno existente no tenemos que modificar el campo.
  connect() {
    const perform = this.data.get('perform') === 'true' ? true : false;
    if (!perform) return;

    if ('geolocation' in navigator) {
      navigator.geolocation.getCurrentPosition((pos) => {
        this.gotPosition(pos.coords.latitude, pos.coords.longitude);
      }, this.gotError);
    } else {
      setError('La ubicación del dispositivo no está disponible');
      this.linkTarget.classList.add('disabled');
    }
  }

  // Cuando el navegador responde con la posición, cargamos la URL a Google Maps
  // en el campo correspondiente y habilitamos el link a esta URL.
  gotPosition = (lat, long) => {
    const MAPS_URL = 'https://www.google.com/maps/search/?api=1&query=';
    const url = `${MAPS_URL}${lat},${long}`;
    this.inputTarget.value = url;
    this.linkTarget.href = url;
  }

  gotError = error => {
    let msg = '';
    if (error.code === error.PERMISSION_DENIED) {
      msg = 'Debe permitir el acceso a la ubicación del dispositivo para llenar automáticamente este campo';
    } else if (error.code === error.POSITION_UNAVAILABLE) {
      msg = 'La ubicación del dispositivo no está disponible';
    } else {
      msg = 'Se agotó el tiempo de espera para obtener la ubicación';
    }
    this.setError(msg);
    this.linkTarget.classList.add('disabled');
  }

  setError(msg) {
    this.errorTarget.innerHTML = msg;
  }
}
