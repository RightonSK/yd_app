import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'development_result_edit_model.dart';

class DevelopmentResultEditPage extends StatelessWidget {
  const DevelopmentResultEditPage({
    Key? key,
    required this.developmentResult,
  }) : super(key: key);
  final DevelopmentResult? developmentResult;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DevelopmentResultEditModel>(
      create: (_) => DevelopmentResultEditModel(developmentResult),
      builder: (context, _) => Consumer<DevelopmentResultEditModel>(
        builder: (context, model, _) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('実績を登録'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: model.validate
                        ? () => model.registerDevelopmentResult(context)
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey[300]!;
                          }
                          return Colors.white;
                        },
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.white;
                          }
                          return primaryNavyColor;
                        },
                      ),
                      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                        (Set<MaterialState> states) {
                          return const TextStyle(fontWeight: FontWeight.bold);
                        },
                      ),
                    ),
                    child: const Text('保存'),
                  ),
                ),
              ],
            ),
            body: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'タイトル',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CommonTextFormField(
                            controller: model.titleController,
                            hintText: '（例）地域特化型マッチングアプリの新規開発',
                            maxLength: 20,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'URL',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CommonTextFormField(
                            controller: model.urlController,
                            keyboardType: TextInputType.url,
                            hintText: 'GitHubリポジトリやストアへのリンクなど',
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '概要',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CommonTextFormField(
                            controller: model.descriptionController,
                            hintText:
                                'あなたの強みが伝わるよう簡潔に入力しましょう。\nチーム開発であれば担当した箇所の記入もお願いします。',
                            lines: 10,
                            maxLength: 400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
