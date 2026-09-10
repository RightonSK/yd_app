import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MentorPlanListPage extends StatelessWidget {
  static const String route = '/mentor_plan_list';
  final PreferredSizeWidget? appBar;

  const MentorPlanListPage({
    Key? key,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MentorPlanListModel>(
      create: (_) => MentorPlanListModel()..init(context),
      builder: (context, child) {
        return Consumer<MentorPlanListModel>(builder: (context, model, child) {
          final mentorPlans = model.mentorPlans;

          if (mentorPlans == null) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }

          return Scaffold(
            appBar: appBar,
            body: GridView(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                childAspectRatio: 10 / 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              children: mentorPlans.map((e) => MentorPlanCard(e)).toList(),
            ),
            floatingActionButton: kIsWeb
                ? FloatingActionButton.extended(
                    onPressed: () {
                      context.go(TeacherPage.route);
                    },
                    backgroundColor: primaryYellowColor,
                    icon: const Icon(
                      Icons.school,
                      color: Colors.black,
                    ),
                    label: const Text(
                      '講師になる',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          );
        });
      },
    );
  }
}

class MentorPlanCard extends StatelessWidget {
  const MentorPlanCard(
    this.mentorPlan, {
    Key? key,
  }) : super(key: key);

  final MentorPlan mentorPlan;

  @override
  Widget build(BuildContext context) {
    final user = mentorPlan.user;
    return InkWell(
      onTap: () async {
        final user = mentorPlan.user;
        if (user?.nickname != null) {
          context.push(MemberDetailPage.route('${user!.nickname}?tab=mentor_plan'));
        }
      },
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mentorPlan.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const BoldMultiLineStyle(fontSize: 20),
              ),
              Expanded(
                child: Text(
                  mentorPlan.description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const MultiLineStyle(fontSize: 10),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (user != null)
                    UserCard(
                      user,
                      color: Colors.black,
                    ),
                  const Spacer(),
                  Text(
                    '${mentorPlan.price.getSplitAmount()}円',
                    style: const BoldMultiLineStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 4),
                  if (mentorPlan.futAmount > 0) ...[
                    const Text(
                      'or',
                      style: MultiLineStyle(),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${mentorPlan.futAmount.getSplitAmount()}FUT',
                      style: const BoldMultiLineStyle(fontSize: 15),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
