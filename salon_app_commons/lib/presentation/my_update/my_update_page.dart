import 'package:app_settings/app_settings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../salon_app_commons.dart';

class MyUpdatePage extends StatelessWidget {
  final double photoSize = 80;
  final PreferredSizeWidget appBar;

  const MyUpdatePage({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyUpdateModel>(
      create: (_) => MyUpdateModel()..init(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: appBar,
        body: Consumer<MyUpdateModel>(builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: photoSize,
                          width: photoSize,
                          child: InkWell(
                            onTap: () async {
                              model.startLoading();

                              try {
                                // ギャラリーから画像を取得する
                                await model.pickPhotoFileAndUpload(context);

                                await showTextDialog(
                                  context,
                                  'プロフィール画像を保存しました',
                                );
                              } on PlatformException catch (e) {
                                if (e.code == 'photo_access_denied') {
                                  await showTextDialog(
                                    context,
                                    '設定にて写真のアクセスを許可してください',
                                  );
                                  AppSettings.openAppSettings();
                                } else {
                                  await showTextDialog(
                                      context, e.message ?? 'エラーが起こりました');
                                }
                              } on FirebaseException catch (e) {
                                await showTextDialog(
                                    context, e.message ?? 'エラーが起こりました');
                              } catch (e) {
                                await showTextDialog(context, e.toString());
                              } finally {
                                model.endLoading();
                              }
                            },
                            child: model.userPhotoUrl != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(model.userPhotoUrl!),
                                    backgroundColor: Colors.transparent,
                                  )
                                : CircleAvatar(
                                    backgroundColor: primaryNavyColor,
                                    radius: photoSize / 2,
                                    child: const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        if (!kIsWeb)
                          TextButton(
                            child: const Text(
                              'プロフィール写真を消去',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onPressed: () async {
                              if (await showConfirmDialog(
                                  context, 'プロフィール画像を削除しますか？')) {
                                // 削除する
                                model.startLoading();
                                try {
                                  await model.deletePhoto();
                                  await showTextDialog(context, '削除しました');
                                } catch (e) {
                                  await showTextDialog(context, e.toString());
                                }
                                model.endLoading();
                              }
                            },
                          ),
                        const Divider(
                          color: Colors.black45,
                        ),
                        ListTile(
                          title: const Text('ニックネーム'),
                          subtitle: Text(model.user?.nickname ?? ''),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyNameUpdatePage(
                                  userName: model.user?.nickname,
                                ),
                              ),
                            );
                            model.init();
                          },
                        ),
                        const Divider(color: Colors.black45),
                        const PrefectureWidget(),
                        const Divider(color: Colors.black45),
                        ListTile(
                          title: const Text('自己紹介'),
                          subtitle: Text(model.user?.bio ?? '自己紹介を書こう'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyBioUpdatePage(
                                  appBar: const LogoAppBar(
                                    isUnderRegister: false,
                                    isLogin: false,
                                  ),
                                  userBio: model.user?.bio,
                                ),
                              ),
                            );
                            model.init();
                          },
                        ),
                        const Divider(
                          color: Colors.black45,
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

class PrefectureWidget extends StatelessWidget {
  const PrefectureWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MyUpdateModel>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '都道府県',
            style: TextStyle(fontSize: 16),
          ),
          DropdownButton(
            value: model.user?.prefecture ?? Prefecture.UNSELECTED,
            items: Prefecture.values.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item.nameJpn),
              );
            }).toList(),
            onChanged: (value) =>
                model.changeUserPrefecture(value as Prefecture),
          ),
        ],
      ),
    );
  }
}
