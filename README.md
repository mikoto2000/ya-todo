# ya todo

[ya-rails-template](https://github.com/mikoto2000/ya-rails-template) をベースにした TODO アプリ。


## 開発環境

VSCode Container 拡張機能を使うか、 Docker Compose で開発環境を立ち上げます。

### VSCode Container 拡張機能による開発

Dev container の環境を整え、本ディレクトリで VSCode を起動し、リモートコンテナへ接続してください。

`code .` で VSCode を起動した後、 `Ctrl-P` -> `Reopen in Container` を選択。

Dev container の環境構築については、以下を参照。

- [Dev Container on WSL2で開発環境構築](https://zenn.dev/ykdev/articles/14a108290e24f9)
- [Windows+WSL2+Ubuntu22.04+VS Code Dev ContainerでWEBシステム開発しよう！](https://zenn.dev/algovitae/articles/2022devcontainer)

### Docker Compose コマンドによる開発

#### 起動

```sh
docker compose up
```

#### 開発コンテナへの接続

以下コマンドで、 ruby, nodejs, yarn の環境構築済みのコンテナに入れます。

```sh
docker compose exec app bash
```


## License

Copyright (C) 2023 mikoto2000

This software is released under the MIT License, see LICENSE

このソフトウェアは MIT ライセンスの下で公開されています。 LICENSE を参照してください。

## Author

mikoto2000 <mikoto2000@gmail.com>


## 参考資料

- [mikoto2000/ya-rails-template: Rails7 標準の scaffold に、いくつか機能を追加したテンプレートです。](https://github.com/mikoto2000/ya-rails-template)
- [Dev Container on WSL2で開発環境構築](https://zenn.dev/ykdev/articles/14a108290e24f9)
- [Windows+WSL2+Ubuntu22.04+VS Code Dev ContainerでWEBシステム開発しよう！](https://zenn.dev/algovitae/articles/2022devcontainer)
- [VSCode Remote Containerをコマンドラインから直接開くことができるようになったのでやってみた - Qiita](https://qiita.com/shimi7o/items/ece71a23e4cf45022ae9)
