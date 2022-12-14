import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager({Key? key, required this.isLoading, required this.child})
      : super(key: key);
  final bool isLoading;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        child,
        isLoading
            ? ColoredBox(
                color: Colors.black.withOpacity(0.7),
              )
            : const SizedBox(),
        isLoading
            ? Center(
                child: SpinKitFadingFour(
                  color: theme.primaryColor,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
