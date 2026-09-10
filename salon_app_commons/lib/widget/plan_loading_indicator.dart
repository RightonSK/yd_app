import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// Common loading indicator widget for plan-related operations
class PlanLoadingIndicator extends StatelessWidget {
  const PlanLoadingIndicator({
    super.key,
    this.message = '金額計算中...',
    this.color = primaryYellowColor,
    this.size = 12,
    this.fontSize = 14,
  });

  final String message;
  final Color color;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: color,
            strokeWidth: 2,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          message,
          style: TextStyle(
            color: Colors.black54,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}

/// Loading indicator specifically for sticky bar
class StickyBarLoadingIndicator extends StatelessWidget {
  const StickyBarLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlanLoadingIndicator(
      message: '金額計算中...',
      color: primaryYellowColor,
    );
  }
}

/// Loading indicator for preview dialogs
class PreviewLoadingIndicator extends StatelessWidget {
  const PreviewLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: themeNavy,
          ),
          SizedBox(height: 8),
          Text(
            '金額の計算中..',
            style: MultiLineStyle(
              color: themeNavy,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}