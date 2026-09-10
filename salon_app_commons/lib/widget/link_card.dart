import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class LinkCard extends StatefulWidget {
  const LinkCard({
    Key? key,
    required this.title,
    required this.isLight,
    required this.onTap,
    required this.isMobile,
    this.author,
    this.isExternalLink = true,
    this.themeColor = primaryNavyColor,
    this.borderColor = Colors.black,
    this.titleColor,
    this.hasBorder = false,
  }) : super(key: key);
  final String title;
  final String? author;
  final bool isLight;
  final bool isExternalLink;
  final void Function() onTap;
  final bool isMobile;
  final Color themeColor;
  final Color borderColor;
  final Color? titleColor;
  final bool hasBorder;

  @override
  State<StatefulWidget> createState() {
    return _ButtonState();
  }
}

class _ButtonState extends State<LinkCard> {
  late Color backgroundColor = widget.isLight ? Colors.white : widget.themeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(64),
      onTap: widget.onTap,
      onHover: (bool hover) {
        setState(() {
          final defaultBackgroundColor = widget.isLight ? Colors.white : widget.themeColor;
          backgroundColor = hover ? defaultBackgroundColor.withOpacity(0.9) : defaultBackgroundColor;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: widget.hasBorder
              ? Border.all(
                  color: widget.borderColor,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(64),
          color: backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: widget.isMobile ? 15 : 17,
                            fontWeight: FontWeight.bold,
                            color: widget.titleColor ?? (widget.isLight ? Colors.black : Colors.white),
                          ),
                    ),
                    if (widget.author != null)
                      const SizedBox(
                        height: 4,
                      ),
                    if (widget.author != null)
                      Text(
                        widget.author!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: widget.isMobile ? 12 : 14,
                              fontWeight: FontWeight.normal,
                              color: widget.isLight ? widget.themeColor : Colors.white,
                            ),
                      ),
                  ],
                ),
              ),
              widget.isExternalLink
                  ? Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isLight ? widget.themeColor : Colors.white, // inner circle color
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: widget.isLight ? Colors.white : widget.themeColor,
                      ),
                    )
                  : Icon(
                      Icons.keyboard_arrow_right,
                      color: widget.isLight ? widget.themeColor : Colors.white,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
