import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'zenn_input_model.dart';

class ZennInputPage extends StatelessWidget {
  static const String route = '/zenn_input';

  final PreferredSizeWidget appBar;
  const ZennInputPage({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryNavyColor,
      appBar: appBar,
      body: ChangeNotifierProvider<ZennInputModel>(
          create: (_) => ZennInputModel(),
          builder: (context, child) {
            return Consumer<ZennInputModel>(builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'salon_app_commons/resources/zenn.png',
                          width: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Zennのユーザー名を入力してください。',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '例：プロフィールURLが https://zenn.dev/kboy であれば「kboy」',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: model.textController,
                        decoration: const InputDecoration(
                          hintText: 'kboy',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: RoundedMoveButton(
                        isMobile: true,
                        isLoading: model.isLoading,
                        title: '登録する',
                        onTap: () async {
                          model.startLoading();

                          try {
                            await model.updateZennId(model.textController.text);
                            // github登録に遷移
                            await showTextDialog(context, 'zennを登録しました🎉');
                            context.pop();
                          } catch (e) {
                            showTextDialog(context, e.toString());
                          } finally {
                            model.endLoading();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            });
          }),
    );
  }
}
