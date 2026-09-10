import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class NicknameInputPage extends StatelessWidget {
  static const String route = '/nickname_input';

  final _nickNameController = TextEditingController(text: '');

  final String? planName;
  final PreferredSizeWidget appBer;
  NicknameInputPage(this.planName, {Key? key, required this.appBer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NicknameInputModel>(
      create: (_) => NicknameInputModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: appBer,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const NewUserInputIndicator(1),
                const SizedBox(height: 16),
                Text(
                  'Flutter大学で使う\nニックネームを登録してください',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nickNameController,
                    decoration: const InputDecoration(
                      hintText: 'ニックネーム',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Consumer<NicknameInputModel>(
                      builder: (context, model, child) {
                    return RoundedMoveButton(
                      isMobile: true,
                      isLoading: model.isLoading,
                      title: '登録する',
                      onTap: () async {
                        model.startLoading();

                        try {
                          await model.updateNickname(_nickNameController.text);
                          // slack登録に遷移
                          if (planName != null) {
                            context.go(
                              '${SlackInputPage.route}?plan=$planName',
                            );
                          } else {
                            context.go(SlackInputPage.route);
                          }
                          await AnalyticsUtils.sendLog(
                              AnalyticsEvent.btnRegisterNickname);
                        } catch (e) {
                          showTextDialog(context, e.toString());
                        } finally {
                          model.endLoading();
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
