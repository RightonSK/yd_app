import 'package:flutter/material.dart';

import '../salon_app_commons.dart';

class RoundedMoveButton extends StatefulWidget {
  const RoundedMoveButton({
    Key? key,
    required this.isMobile,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.backgroundColor = Colors.white,
    this.textColor = primaryNavyColor,
    this.width,
    this.onHover,
    this.iconData,
  }) : super(key: key);
  final bool isMobile;
  final String title;
  final void Function()? onTap;
  final void Function(bool)? onHover;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final IconData? iconData;

  @override
  State<StatefulWidget> createState() {
    return _RoundedButtonState();
  }
}

class _RoundedButtonState extends State<RoundedMoveButton> {
  late Color backgroundColor = widget.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.onTap != null ? 1 : 0.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.isMobile ? 33 : 50),
        onTap: widget.isLoading ? null : widget.onTap,
        onHover: (bool hover) {
          setState(() {
            backgroundColor = hover ? widget.backgroundColor.withOpacity(0.9) : widget.backgroundColor;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.isMobile ? 33 : 50),
            color: backgroundColor,
            boxShadow: [
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
          width: widget.width ?? (widget.isMobile ? 300 : 520),
          height: widget.isMobile ? 66 : 100,
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: primaryNavyColor,
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.iconData != null)
                            Icon(
                              widget.iconData,
                              color: widget.textColor,
                            ),
                          if (widget.iconData != null) const SizedBox(width: 6),
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: widget.isMobile ? 20 : 32,
                                  fontWeight: FontWeight.bold,
                                  color: widget.textColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: widget.isMobile ? 12 : 24),
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: widget.textColor,
                          size: widget.isMobile ? 20 : 32,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
