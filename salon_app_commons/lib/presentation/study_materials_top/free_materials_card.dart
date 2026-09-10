import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class FreeMaterialsCard extends StatelessWidget {
  const FreeMaterialsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'すべてのプランの方向け',
                  style: BoldMultiLineStyle(fontSize: 20),
                ),
                const SizedBox(width: 4),
                Column(
                  children: [
                    const SizedBox(height: 3),
                    InkWell(
                      child: const Tooltip(
                        message: 'Flutter学習ロードマップはこちら',
                        child: Icon(
                          Icons.help,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      onTap: () {
                        URLUtils.launch(
                          urlString:
                              'https://zenn.dev/flutteruniv_dev/articles/flutter-roadmap',
                          shouldOpenNewTab: true,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Text(
              'すべての方が閲覧できる、Flutter大学が出している教材のまとめです。',
              style: MultiLineStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 128,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MaterialContainer(
                    imagePath:
                        'salon_app_commons/resources/thum_flutter_guide1.png',
                    onTap: () {
                      URLUtils.launch(
                        urlString:
                            'https://www.youtube.com/playlist?list=PLuLRJz1UnJzEZ9r3S1zDHLmUK1ukZSN2x',
                        shouldOpenNewTab: true,
                      );
                    },
                  ),
                  const SizedBox(width: 24),
                  MaterialContainer(
                    imagePath:
                        'salon_app_commons/resources/thum_flutter_guide2.png',
                    onTap: () {
                      URLUtils.launch(
                        urlString:
                            'https://www.youtube.com/playlist?list=PLuLRJz1UnJzEIopXyUrV7kDn8erUyu7lm',
                        shouldOpenNewTab: true,
                      );
                    },
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

class MaterialContainer extends StatelessWidget {
  final String? imagePath;
  final void Function()? onTap;

  const MaterialContainer({
    Key? key,
    this.imagePath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 10.0,
              spreadRadius: .1,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            imagePath!,
            fit: BoxFit.contain,
            width: 120,
          ),
        ),
      ),
    );
  }
}
