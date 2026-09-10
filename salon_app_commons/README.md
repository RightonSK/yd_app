salon_appとsalon_app_webとsalon_admin_webの共通部分をまとめたリポジトリです。

git submoduleで導入して、以下のようにpubspec.yamlのdependenciesの１としてpathで指定してローカルから呼び出して使います。

```
  salon_app_commons:
    path: salon_app_commons
```