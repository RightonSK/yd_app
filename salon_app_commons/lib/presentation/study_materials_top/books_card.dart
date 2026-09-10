import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class BooksCard extends StatelessWidget {
  const BooksCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '課題学習プラン以上向け',
                style: BoldMultiLineStyle(fontSize: 20),
              ),
              const Text(
                '課題学習プラン以上のメンバーはzennで公開されている有料本で勉強できます。閲覧にはGitHubへのログインとOrganizationへの登録が必要です。',
                style: MultiLineStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 128,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      BookContainer(
                        imagePath: 'salon_app_commons/resources/textbook_cover.png',
                      ),
                      SizedBox(width: 24),
                      BookContainer(
                        imagePath: 'salon_app_commons/resources/textbook2_cover.png',
                      ),
                      SizedBox(width: 24),
                      BookContainer(
                        imagePath: 'salon_app_commons/resources/places-textbook-cover.png',
                      ),
                      SizedBox(width: 24),
                      BookContainer(
                        imagePath: 'salon_app_commons/resources/dart-textbook-cover.png',
                      ),
                      SizedBox(width: 24),
                      BookContainer(
                        imagePath: 'salon_app_commons/resources/architect-textbook-cover.png',
                      ),
                      SizedBox(width: 24),
                      BlackOverlayWidget(
                        text: '執筆予定',
                        child: BookContainer(
                          imagePath: 'salon_app_commons/resources/revenue-textbook-cover.png',
                        ),
                      ),
                      SizedBox(width: 24),
                      BlackOverlayWidget(
                        text: '執筆予定',
                        child: BookContainer(
                          imagePath: 'salon_app_commons/resources/riverpod-textbook-cover.png',
                        ),
                      ),
                    ],
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

class BookContainer extends StatelessWidget {
  final String? imagePath;

  const BookContainer({
    Key? key,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final baseURL = URLUtils.getBaseUrl();
        URLUtils.launch(
          urlString: '$baseURL/zenn',
          shouldOpenNewTab: true,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
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
          borderRadius: BorderRadius.circular(2),
          child: Image.asset(
            imagePath!,
            fit: BoxFit.contain,
            width: 80,
          ),
        ),
      ),
    );
  }
}

class BlackOverlayWidget extends StatelessWidget {
  const BlackOverlayWidget({
    Key? key,
    required this.child,
    required this.text,
  }) : super(key: key);

  final Widget child;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.black45,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const MultiLineStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        )
      ],
    );
  }
}
