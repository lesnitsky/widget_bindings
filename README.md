## Widgets Binding

A library that allows to easily bind data holders or observables to the widget tree.

```dart
stream.$bind(
    context: context,
    successBuilder: (context, data, child) { ... },
)

future.$bind(
    context: context,
    successBuilder: (context, data, child) { ... },
)

valueNotifier.$bind(
    context: context,
    builder: (context, data, child) { ... },
)

listenable.$bind(
    context: context,
    builder: (context, child) { ... },
)
```

### License

MIT
