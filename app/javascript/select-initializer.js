import TomSelect from "tom-select"

window.setupTomSelectForSingleSelect = function setupTomSelectForSingleSelect() {
  document.querySelectorAll('select').forEach((e) => {
    if (!e.tomselect) {
      new TomSelect(e, {
        plugins: {
          remove_button: {
            title:'Remove this item',
          }
        },
        field: 'text',
        direction: 'asc'
      });
    }
  });
}

window.setupTomSelectForMultiSelect = function setupTomSelectForSingleSelect() {
  document.querySelectorAll('select').forEach((e) => {
    if (!e.tomselect) {
      new TomSelect(e, {
        plugins: {
          remove_button: {
            title:'Remove this item',
          }
        },
        field: 'text',
        direction: 'asc'
      });
    }
  });
}
