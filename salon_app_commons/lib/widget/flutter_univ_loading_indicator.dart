import 'package:flutter/material.dart';

class FlutterUnivLoadingIndicator extends StatelessWidget {
  const FlutterUnivLoadingIndicator({
    super.key,
    this.backgroundColor = Colors.white,
    this.width = 44,
  });
  final Color backgroundColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: SizedBox(
          width: width,
          height: width,
          child: Image.asset('resources/loading.gif'),
        ),
      ),
    );
  }
}
