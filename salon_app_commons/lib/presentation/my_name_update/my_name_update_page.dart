import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MyNameUpdatePage extends StatelessWidget {
  MyNameUpdatePage({super.key, this.userName});
  final String? userName;
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = userName ?? '';
    return ChangeNotifierProvider<MyNameUpdateModel>(
      create: (_) => MyNameUpdateModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          centerTitle: true,
          title: const Text('ニックネームの変更'),
        ),
        body: Consumer<MyNameUpdateModel>(builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('新しいニックネーム'),
                    TextField(
                      autofocus: true,
                      controller: nameController,
                      decoration: InputDecoration(
                        suffix: IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            nameController.clear();
                          },
                        ),
                      ),
                      onChanged: (text) {
                        model.newName = text.trim();
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text('このニックネームは他のFlutter大学メンバーに公開されます。'),
                    const SizedBox(height: 16),
                    Center(
                      child: RoundedActionButton(
                        width: double.infinity,
                        backgroundColor: primaryNavyColor,
                        textColor: Colors.white,
                        isMobile: false,
                        title: 'ニックネームを変更する',
                        onTap: () async {
                          model.startLoading();
                          try {
                            await model.updateName();
                            await _showTextDialog(context, 'ニックネームを変更しました');
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
