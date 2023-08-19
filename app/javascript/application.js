// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

// 行儀が悪いが、 HTML から直接 select 初期化関数を呼び出せるように、副作用付きインポートを行う
// (windows オブジェクト直下に select 初期化関数をぶら下げる)
import "./select-initializer"

// 行儀が悪いが、グローバルに展開してしまう
import { handleEnterKeypressListItem, handleClickListItem, handleDeleteListItem, clear_form, updateItemPerPage, handleOnChangePagyItemsSelectorJs } from "./ya-common"
window.handleEnterKeypressListItem = handleEnterKeypressListItem;
window.handleClickListItem = handleClickListItem;
window.handleDeleteListItem = handleDeleteListItem;
window.clear_form = clear_form;
window.updateItemPerPage = updateItemPerPage;
window.handleOnChangePagyItemsSelectorJs = handleOnChangePagyItemsSelectorJs;

document.addEventListener("DOMContentLoaded", function() {
  document.addEventListener('turbo:load', function() {

    const observer = new MutationObserver(function(mutationsList, observer) {
      for(let mutation of mutationsList) {
        if (mutation.type === 'childList') {
          setupTomSelectForMultiSelect();
        }
      }
    });

    if (document.getElementById("new-todo-container")) {
      observer.observe(document.getElementById("new-todo-container"), { childList: true });
    }

    setupTomSelectForMultiSelect();
  });
  document.addEventListener('turbo:render', function() {
    setupTomSelectForMultiSelect();
  });
  document.addEventListener('turbo:frame-load', function() {
    setupTomSelectForMultiSelect();
  });
  document.addEventListener('turbo:frame-render', function() {
    setupTomSelectForMultiSelect();
  });

});
