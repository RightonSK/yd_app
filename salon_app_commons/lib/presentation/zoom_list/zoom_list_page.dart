import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class ZoomListPage extends StatelessWidget {
  static const String route = '/zoom_list';

  const ZoomListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ZoomListModel>(
      create: (_) => ZoomListModel()..init(context),
      builder: (context, child) {
        return Consumer<ZoomListModel>(builder: (context, model, child) {
          final events = model.events;

          if (events == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          return Scaffold(
            body: GridView(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 16 / 13,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              children: events.map((e) => EventCard(e)).toList(),
            ),
          );
        });
      },
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard(
    this.event, {
    Key? key,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    final isOpen = event.isOpen ?? false;
    return InkWell(
      onTap: isOpen
          ? () async {
              context.go('/${event.id}');
            }
          : null,
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: event.imageURL != null
                      ? Image.network(
                          event.imageURL!,
                          width: double.infinity,
                        )
                      : const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: const BoldMultiLineStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(event.createTimeText()),
                    ],
                  ),
                ),
              ],
            ),
            if (!isOpen)
              const ColoredBox(
                color: Colors.black54,
                child: Center(
                  child: Text(
                    '時間外',
                    style: BoldMultiLineStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
