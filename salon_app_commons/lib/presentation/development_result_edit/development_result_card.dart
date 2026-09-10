import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:salon_app_commons/domain/development_result.dart';
import 'package:url_launcher/url_launcher.dart';

/// 開発実績を表すカード
class DevelopmentResultCard extends StatelessWidget {
  const DevelopmentResultCard({
    Key? key,
    required this.developmentResult,
    this.onTap,
    this.deleteCallback,
  }) : super(key: key);
  final DevelopmentResult developmentResult;
  final void Function()? onTap;
  final void Function()? deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () =>
                          launchUrl(Uri.parse(developmentResult.url)),
                      child: Text(
                        developmentResult.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (deleteCallback != null)
                    IconButton(
                      onPressed: deleteCallback,
                      color: Colors.red,
                      icon: const Icon(Icons.delete),
                    ),
                ],
              ),
              Linkify(
                text: developmentResult.description,
                onOpen: (link) {
                  launchUrl(Uri.parse(link.url));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
