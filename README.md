# AngularDart base href rewriter ([Builder](https://pub.dartlang.org/packages/build))

This builder take your `web/index.html` ans add or edit the `base href` according to your configuration.
The result is save in `web/index.basehref.html`


#### Using with [AngularDart](https://webdev.dartlang.org/angular) or in you dart web project :

Add this package to your `pubspec.yaml` file :

```
dev_dependencies:
  basehref: ^0.5.1
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

and build your project with :

```
pub run build_runner build --delete-conflicting-outputs --release --output ./build
```

The result is stored in `./build/web/index.basehref.html` (to my knowledge there is no way to replace the `index.html` with a `Builder` and/or `PostProcessBuilder`) : 
https://stackoverflow.com/questions/52397358/dart-build-config-rename-buildstep-inputid-file
