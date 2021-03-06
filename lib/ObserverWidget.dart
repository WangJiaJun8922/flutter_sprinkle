import 'dart:async';
import 'package:flutter/material.dart';

class ObserverWidget<T> extends StatelessWidget {
  @required
  final Stream<T> stream;
  final T initialData;
  @required
  final Function onSuccess;
  final Function onError;
  final Function onWaiting;

  const ObserverWidget({this.onError, this.onSuccess, this.stream, this.initialData, this.onWaiting});

  Function get _defaultOnWaiting =>
      (context) => Center(child: CircularProgressIndicator());
  Function get _defaultOnError => (context, error) => Text(error);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      initialData: initialData,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return (onError != null)
              ? onError(context, snapshot.error)
              : _defaultOnError(context, snapshot.error);
        }

        if (snapshot.hasData) {
          T data = snapshot.data;
          return onSuccess(context, data);
        } else {
          return (onWaiting != null)
              ? onWaiting(context)
              : _defaultOnWaiting(context);
        }
      },
    );
  }
}
