import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef Builder = Widget Function(BuildContext context, Widget? child);

typedef LoadingBuilder<T> = Widget Function(BuildContext context, T progress);

typedef SuccessBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  Widget? child,
);

typedef ErrorBuilder = Widget Function(
  BuildContext,
  Object? error,
);

extension StreamBinding<T> on Stream<T> {
  /// Binds a stream to a widget tree.
  Widget $bind({
    required SuccessBuilder<T> successBuilder,
    LoadingBuilder<ConnectionState>? loadingBuilder,
    ErrorBuilder? errorBuilder,
    Widget? child,
  }) {
    return StreamBuilder<T>(
      stream: this,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (null is T) {
            final data = snapshot.data;
            return (successBuilder as SuccessBuilder<T?>)(context, data, child);
          }

          return successBuilder(context, snapshot.requireData!, child);
        } else if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error) ??
              const SizedBox();
        } else {
          return loadingBuilder?.call(context, snapshot.connectionState) ??
              const SizedBox();
        }
      },
    );
  }
}

extension FutureBinding<T> on Future<T> {
  /// Binds a future to a widget tree.
  Widget $bind({
    required SuccessBuilder<T> successBuilder,
    LoadingBuilder<ConnectionState>? loadingBuilder,
    ErrorBuilder? errorBuilder,
    Widget? child,
  }) {
    return FutureBuilder<T>(
      future: this,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (null is T) {
            final data = snapshot.data;
            return (successBuilder as SuccessBuilder<T?>)(context, data, child);
          }

          return successBuilder(context, snapshot.requireData, child);
        } else if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error) ??
              const SizedBox();
        } else {
          return loadingBuilder?.call(context, snapshot.connectionState) ??
              const SizedBox();
        }
      },
    );
  }
}

extension ValueNotifierBinding<T> on ValueListenable<T> {
  /// Binds a value notifier to a widget tree.
  Widget $bind({
    required SuccessBuilder<T> builder,
    Widget? child,
  }) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (context, value, child) {
        if (null is T) {
          final data = value;
          return (builder as SuccessBuilder<T?>)(context, data, child);
        }

        return builder(context, value, child);
      },
    );
  }
}

extension ListenableBinding on Listenable {
  /// Binds a listenable to a widget tree.
  Widget $bind({
    required Builder builder,
    Widget? child,
  }) {
    return AnimatedBuilder(
      animation: this,
      builder: (context, child) {
        return builder(context, child);
      },
      child: child,
    );
  }
}
