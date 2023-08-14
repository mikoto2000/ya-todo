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

