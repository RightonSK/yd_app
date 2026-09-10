import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/presentation/slack_times_input/slack_times_input_model.dart';
import 'package:salon_app_commons/utils/dialog_utils.dart';
import 'package:salon_app_commons/widget/rounded_move_button.dart';

/// ログイン
class SlackTimesInputBody extends StatelessWidget {
  final _emailController = TextEditingController(text: '');

  SlackTimesInputBody({
    Key? key,
    required this.onCompleteInputTimes,
  }) : super(key: key);

  final Function() onCompleteInputTimes;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SlackTimesInputModel>(
        create: (_) => SlackTimesInputModel()..fetchUserAndCheckTimesId(),
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 16),
                Text(
                  'Slackのtimes_〇〇チャンネルを作成後、\nこちらにチャンネル名を入力してください。',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'times_kboy',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Consumer<SlackTimesInputModel>(builder: (context, model, child) {
                    if (model.slackTimesIdExists == null) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    return RoundedMoveButton(
                      isMobile: true,
                      isLoading: model.isLoading,
                      title: model.slackTimesIdExists! ? '入力済みです' : '確認する',
                      onTap: model.slackTimesIdExists!
                          ? null
                          : () async {
                              model.startLoading();

                              try {
                                await model.checkIsThereTimesAndGetFUT(_emailController.text);
                                // github登録に遷移
                                await showTextDialog(context, '50FUTをゲットしました🎉');
                                onCompleteInputTimes();
                              } catch (e) {
                                showTextDialog(context, e.toString());
                              } finally {
                                model.endLoading();
                              }
                            },
                    );
                  }),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
  }
}
