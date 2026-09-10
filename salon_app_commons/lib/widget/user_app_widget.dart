import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';

class UserAppWidget extends StatelessWidget {
  final UserApp app;
  const UserAppWidget(this.app, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(UserAppDetailPage.route, extra: app);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: app.appIconImageURL != null &&
                        app.appIconImageURL!.isNotEmpty
                    ? FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: app.appIconImageURL!,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          // フィードのエラーハンドリング
                          return ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation,
                            ),
                            child: Image.asset(
                              'resources/logo.jpg',
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )
                    : ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                        child: Image.asset(
                          'resources/logo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            app.getDisplayReleaseDate(),
            style: const TextStyle(
              height: 1,
              fontSize: 10,
              color: primaryNavyColor,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 32,
            child: Text(
              app.appTitle!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class AddAppWidget extends StatelessWidget {
  const AddAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AddUserAppsPage.route);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.black12,
                    child: const Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                  ),
                )),
            const SizedBox(
              height: 4,
            ),
            const SizedBox(
              height: 42,
              child: Text(
                'アプリを\n追加する',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
