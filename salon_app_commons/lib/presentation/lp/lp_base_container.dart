import 'package:flutter/material.dart';

class LPBaseContainer extends StatelessWidget {
  const LPBaseContainer({
    Key? key,
    required this.child,
    this.color,
    this.backgroundImageName,
    this.padding,
    this.bodyMaxWidth,
    required this.isMobile,
  }) : super(key: key);
  final Widget child;
  final Color? color;
  final String? backgroundImageName;
  final EdgeInsetsGeometry? padding;
  final double? bodyMaxWidth;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        image: backgroundImageName != null
            ? DecorationImage(
                image: AssetImage(backgroundImageName!),
                fit: BoxFit.fill,
              )
            : null,
      ),
      padding: padding ??
          (isMobile
              ? const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 32,
                )
              : const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 64,
                )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: bodyMaxWidth ?? 1024),
            child: child,
          ),
        ],
      ),
    );
  }
}
