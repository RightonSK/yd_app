import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MyBioUpdatePage extends StatelessWidget {
  MyBioUpdatePage({
    super.key,
    this.userBio,
    required this.appBar,
  });

  final PreferredSizeWidget appBar;
  final String? userBio;
  final TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bioController.text = userBio ?? '';
    return ChangeNotifierProvider<MyBioUpdateModel>(
      create: (_) => MyBioUpdateModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: appBar,
        body: Consumer<MyBioUpdateModel>(builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('新しい自己紹介'),
                        TextField(
                          autofocus: true,
                          controller: bioController,
                          decoration: InputDecoration(
                            suffix: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                bioController.clear();
                              },
                            ),
                          ),
                          onChanged: (text) {
                            model.newBio = text.trim();
                          },
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: RoundedActionButton(
                            width: double.infinity,
                            backgroundColor: primaryNavyColor,
                            textColor: Colors.white,
                            isMobile: false,
                            title: '自己紹介文を変更する',
                            onTap: () async {
                              model.startLoading();
                              try {
                                await model.updateName();
                                await _showTextDialog(context, '自己紹介を変更しました');
                                Navigator.of(context).pop();
                              } catch (e) {
                                _showTextDialog(context, e.toString());
                              } finally {
                                model.endLoading();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              model.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox()
            ],
          );
        }),
      ),
    );
  }
}

_showTextDialog(context, message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
