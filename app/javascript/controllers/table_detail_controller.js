import $ from 'jquery';
import { Controller } from 'stimulus';

export default class extends Controller {
  collapse = (e) => {
    const button = $(e.target);
    const row = button.parents('tr').next().find('.detail-row-content');

    row.slideToggle(200, () => {
      row.parent().toggleClass('expanded');
      button.find('i.fa').toggleClass('fa-caret-right fa-caret-down');
    });
  }
}
