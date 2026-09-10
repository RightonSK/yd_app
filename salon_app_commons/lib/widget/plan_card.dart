import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    Key? key,
    required this.isMobile,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.priceText,
    this.textColor,
  }) : super(key: key);

  final bool isMobile;
  final String? imageUrl;
  final String? name;
  final String? description;
  final String? priceText;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: textColor ?? Colors.white,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              width: isMobile ? 80 : 160,
              padding: const EdgeInsets.all(8),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      'salon_app_commons/resources/img_plan_default.png',
                      fit: BoxFit.fill,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 4 : 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: isMobile ? 12 : 24,
                            fontWeight: FontWeight.bold,
                            color: textColor ?? Colors.white,
                          ),
                    ),
                    Text(
                      '$priceText',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: textColor ?? Colors.white,
                          ),
                    ),
                    Text(
                      description ?? '',
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: isMobile ? 7 : 14,
                            color: textColor ?? Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
