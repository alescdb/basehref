# AngularDart base href rewriter ([Builder](https://pub.dartlang.org/packages/build))

This builder take your `web/index.html` ans add or edit the `base href` according to your configuration.
The result is save in `web/index.basehref.html`


#### Using with [AngularDart](https://webdev.dartlang.org/angular)

Add this package to your pubspec.yaml file :

```
dev_dependencies:
  basehref:
    git: https://github.com/alescdb/basehref
```

Then create or add to `build.yaml` :

```
targets:
  $default:
    builders:
      basehref|baseHrefBuilder:
        enabled: true
        options:
          href: '/my/application/base/href/'
```

and build your project :

```
pub run build_runner build
```