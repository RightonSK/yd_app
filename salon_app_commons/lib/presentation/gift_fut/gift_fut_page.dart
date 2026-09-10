import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class GiftFUTPage extends StatelessWidget {
  const GiftFUTPage({
    super.key,
    required this.toUser,
  });
  final User toUser;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GiftFUTModel>(
      create: (_) => GiftFUTModel()..fetchUserAndTransaction(),
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: primaryNavyColor,
        body: Consumer<GiftFUTModel>(builder: (context, model, child) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "${toUser.nickname}にFUTをギフトする",
                        style: const BoldMultiLineStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 240,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 6,
                              controller: model.textEditingController,
                              showCursor: false,
                              textAlign: TextAlign.right,
                              autofocus: true,
                              style: const BoldMultiLineStyle(
                                fontSize: 64,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                hintText: "0",
                                counterText: '',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Column(
                            children: const [
                              Text(
                                "FUT",
                                style: BoldMultiLineStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (kIsWeb)
                        const Text(
                          '※キーボードで入力してください',
                          style: MultiLineStyle(
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(
                        height: 32,
                      ),
                      RoundedMoveButton(
                        isMobile: true,
                        onTap: () async {
                          try {
                            await model.fetchUserAndTransaction();
                            await model.sendFUT(toUser);

                            showTextDialog(
                                context, '${toUser.nickname}さんにFUTがギフトされました🎉');
                          } catch (e) {
                            showErrorDialogAndInquiryChat(context, e);
                          } finally {
                            model.endLoading();
                          }
                        },
                        title: '送る',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
