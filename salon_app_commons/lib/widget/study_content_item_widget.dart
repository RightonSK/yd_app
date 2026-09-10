import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class StudyContentItemWidget extends StatelessWidget {
  final String thumbURL;
  final String title;
  final String createdAt;
  final bool isNew;
  final double ratio;
  final bool isDarkColor;
  final bool isDone;
  final void Function() onTap;

  const StudyContentItemWidget({
    super.key,
    required this.thumbURL,
    required this.title,
    required this.createdAt,
    required this.isNew,
    required this.ratio,
    required this.onTap,
    this.isDone = false,
    this.isDarkColor = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 160,
                  height: 90,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: thumbURL,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 160,
                        height: 90,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                if (ratio > 0)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 160,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        value: ratio,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkColor ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        createdAt,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      if (isNew)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 6,
                            ),
                            NewLabelWidget()
                          ],
                        ),
                      if (isDone) const Spacer(),
                      if (isDone)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      if (isDone) const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewLabelWidget extends StatelessWidget {
  const NewLabelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      child: const Text(
        'New',
        style: TextStyle(
            fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
