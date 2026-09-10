import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

/// ログイン
class InviteBody extends StatelessWidget {
  const InviteBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InviteModel>(
        create: (_) => InviteModel()..createInviteUrl(),
        builder: (context, child) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 16),
                  const Text(
                    '友達招待でFUTをプレゼント 🎁',
                    style: BoldMultiLineStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '以下のリンクから友達が入会すると、あなたに200FUT、友達に100FUTが付与されます',
                    style: MultiLineStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Consumer<InviteModel>(builder: (context, model, child) {
                    final inviteCount = model.inviteCount;
                    return Text(
                      '現在の招待人数: ${inviteCount ?? '..'}人',
                      style: const MultiLineStyle(
                        color: Colors.white,
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  IntrinsicWidth(
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        child: Consumer<InviteModel>(builder: (context, model, child) {
                          final inviteUrl = model.inviteUrl;
                          return Row(
                            children: [
                              Expanded(
                                child: SelectableText(
                                  inviteUrl ?? 'url読み込み中',
                                  style: const MultiLineStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              TextButton(
                                onPressed: inviteUrl != null ? () async {
                                  await Clipboard.setData(ClipboardData(text: inviteUrl!));
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Copied to your clipboard !'),
                                    backgroundColor: primaryYellowColor,
                                  ));
                                } : null,
                                child: const Icon(Icons.copy),
                              )
                            ],
                          );
                        })),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        });
  }
}
