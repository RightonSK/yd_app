import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/domain/reservation.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:transparent_image/transparent_image.dart';

class CalendarPage extends StatelessWidget {
  // static const String route = '/schedule';

  const CalendarPage({
    super.key,
    this.appBar,
    required this.googleToken,
    required this.calendarId,
  });
  final PreferredSizeWidget? appBar;
  final String googleToken;
  final String calendarId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: ChangeNotifierProvider<CalendarModel>(
        create: (_) => CalendarModel(googleToken, calendarId)..init(),
        child: Consumer<CalendarModel>(
          builder: (context, model, child) {
            final eventsMap = model.eventsMap;
            final calendarImageURL = model.calendarImageURL;

            if (eventsMap == null || calendarImageURL == null || model.isLoading) {
              return const FlutterUnivLoadingIndicator();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  InteractiveViewer(
                    minScale: 1,
                    maxScale: 7,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: calendarImageURL,
                      ),
                    ),
                  ),
                  const CalendarWidget(),
                  EventList(items: model.selectedEvents),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CalendarModel>(context);
    return TableCalendar(
      focusedDay: model.focusedDay,
      firstDay: model.startDate!,
      lastDay: model.endDate!,
      eventLoader: (day) {
        final dateKey = DateTime(day.year, day.month, day.day);
        return model.eventsMap![dateKey] ?? [];
      },
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.week: '',
      },
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.blue),
      ),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      selectedDayPredicate: (day) {
        return isSameDay(model.selectedDate, day);
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          final text = DateFormat.E().format(day);
          if (day.weekday == DateTime.sunday) {
            return Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            );
          }
          if (day.weekday == DateTime.saturday) {
            return Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ),
            );
          }
          return Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          );
        },
        markerBuilder: (context, date, events) {
          return const SizedBox();
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        model.onDaySelected(selectedDay);
      },
      onPageChanged: (focusedDay) {
        model.onPageChanged(focusedDay);
      },
    );
  }
}

class EventList extends StatelessWidget {
  const EventList({
    super.key,
    required this.items,
  });
  final List<CalendarItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text('なし'),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final event = items[index];
          return CalendarItemWidget(item: event);
        },
      ),
    );
  }
}

class CalendarItemWidget extends StatelessWidget {
  const CalendarItemWidget({
    Key? key,
    required this.item,
    this.isFeed = false,
  }) : super(key: key);

  final CalendarItem item;
  final bool isFeed;

  @override
  Widget build(BuildContext context) {
    final model = context.read<CalendarModel>();
    final isYouReserved = model.isYouReserved(item);
    final isFull = model.isFull(item);
    final isPast = model.isPast(item);
    final isNow = model.isNow(item);
    final shouldGrayOutReserveButton = model.shouldGrayOutReserveButton(item);
    final reservationCount = model.reservationCount(item);

    return Opacity(
      opacity: isPast ? 0.5 : 1,
      child: IgnorePointer(
        ignoring: isPast,
        child: InkWell(
          onTap: () {
            final urlString = item.description?.extractURL();

            if (urlString == null) {
              return;
            }
            logger.d(urlString);

            if (urlString.contains('flutteruniv.com')) {
              final url = Uri.parse(urlString);
              final route = url.pathSegments.last;
              logger.d(route);
              context.push('/$route');
            } else {
              URLUtils.launch(urlString: urlString);
            }
          },
          child: Container(
            height: item.eventType == EventType.morning ? 64 : 132,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: item.eventType.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.summary ?? '',
                  style: TextStyle(
                    color: item.eventType.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      getDateTimeRangeStr(
                        item.start!.dateTime!,
                        item.end!.dateTime!,
                      ),
                      style: TextStyle(
                        color: item.eventType.textColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isNow)
                      Container(
                        color: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 4,
                        ),
                        child: const Text(
                          'ON AIR',
                          style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                  ],
                ),
                const Spacer(),
                if (item.eventType == EventType.question)
                  Row(
                    children: [
                      if (reservationCount != null)
                        Text(
                          '$reservationCount/${Reservation.limitCount}',
                          style: TextStyle(
                            color: item.eventType.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      const Spacer(),
                      Opacity(
                        opacity: shouldGrayOutReserveButton ? 0.5 : 1,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isYouReserved) {
                              // 予約をキャンセルする
                              final isYes = await showConfirmDialog(
                                context,
                                '${item.summary}の予約をキャンセルしますか？',
                              );

                              if (isYes) {
                                model.cancelQuestionZoom(item);
                                model.startLoading();
                                model.init();
                              }
                            } else {
                              // 予約可能かチェックし、ダメならメッセージを表示
                              final validationMessage = await model.validate(item);
                              if (validationMessage != null) {
                                await showTextDialog(
                                  context,
                                  validationMessage,
                                );
                                return;
                              }

                              // 予約する
                              String reserveText = '${item.summary}を予約しますか？';
                              final isYes = await showConfirmDialog(context, reserveText);

                              if (isYes) {
                                model.startLoading();
                                await model.reserveQuestionZoom(item);
                                model.init();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isYouReserved ? primaryYellowColor : (isFull ? Colors.redAccent : Colors.white),
                          ),
                          child: Text(
                            isYouReserved ? '予約済み' : (isFull ? '満員' : (isPast ? '締切' : '予約する')),
                            style: TextStyle(
                              fontSize: 12,
                              color: isYouReserved
                                  ? Colors.black
                                  : (isFull ? Colors.white : (isPast ? Colors.grey : themeNavy)),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
