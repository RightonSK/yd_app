import 'package:flutter/material.dart';

import '../salon_app_commons.dart';

class RoundedActionButton extends StatefulWidget {
  const RoundedActionButton({
    Key? key,
    required this.isMobile,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.backgroundColor = Colors.white,
    this.textColor = primaryNavyColor,
    this.width,
  }) : super(key: key);
  final bool isMobile;
  final String title;
  final void Function()? onTap;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double? width;

  @override
  State<StatefulWidget> createState() {
    return _RoundedButtonState();
  }
}

class _RoundedButtonState extends State<RoundedActionButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.onTap != null ? 1 : 0.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(33),
        onTap: widget.onTap,
        onHover: (bool hover) {
          setState(() {
            isHover = hover;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33),
            color: isHover
                ? widget.backgroundColor.withOpacity(0.9)
                : widget.backgroundColor,
            boxShadow: [
              if (widget.onTap != null)
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 5,
                  blurStyle: BlurStyle.normal,
                  offset: const Offset(
                    1,
                    1,
                  ),
                )
            ],
          ),
          width: widget.width ?? (widget.isMobile ? 90 : 180),
          height: widget.isMobile ? 44 : 66,
          child: widget.isLoading
              ? Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: widget.textColor,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.textColor,
                          fontSize: widget.isMobile ? 11 : 15,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }
}
