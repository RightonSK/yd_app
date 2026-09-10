import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MyFUTPage extends StatelessWidget {
  static const String route = '/my_fut';
  final PreferredSizeWidget appBar;

  const MyFUTPage({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryNavyColor,
      appBar: appBar,
      body: MyFUTBody(
        onTapAbout: () async {
          context.push(AboutFUTPage.route);
        },
        onTapGift: (BuildContext bodyContext) async {
          // メンバーを受け取る
          final member = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MembersSearchPage(),
            ),
          );
          // メンバーを渡してギフト画面へ
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GiftFUTPage(
                toUser: member,
              ),
            ),
          );
          // ギフト画面から戻ってきた時にデータを再読み込み
          final model = Provider.of<MyFUTModel>(bodyContext, listen: false);
          await model.fetchUserAndTransaction();
        },
        onTapMentor: () async {
          context.push(MentorPlanListPage.route);
        },
      ),
    );
  }
}

class MyFUTBody extends StatelessWidget {
  const MyFUTBody({
    Key? key,
    required this.onTapAbout,
    required this.onTapGift,
    required this.onTapMentor,
  }) : super(key: key);

  final void Function()? onTapAbout;
  final void Function(BuildContext)? onTapGift;
  final void Function()? onTapMentor;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyFUTModel>(
      create: (_) => MyFUTModel()..fetchUserAndTransaction(),
      builder: (context, child) {
        return SingleChildScrollView(
          child: Consumer<MyFUTModel>(builder: (context, model, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 32),
                IntrinsicWidth(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.monetization_on_outlined,
                        color: primaryYellowColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '現在のFUT',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                if (!model.isLoading)
                  Text(
                    model.fut != null ? model.fut.toString() : '0',
                    style: const BoldMultiLineStyle(
                      color: Colors.white,
                      fontSize: 42,
                    ),
                  ),
                const SizedBox(height: 16),
                RoundedMoveButton(
                  isMobile: true,
                  title: 'FUTをゲットする方法',
                  onTap: onTapAbout,
                ),
                const SizedBox(height: 48),
                IntrinsicWidth(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.history,
                        color: primaryYellowColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'FUT取引履歴',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
                if (model.futTransactions != null)
                  model.futTransactions!.isNotEmpty
                      ? Column(
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: ListView.builder(
                                  itemCount: (model.futTransactions!.length > 5) ? 5 : model.futTransactions!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (final BuildContext context, int index) {
                                    final transaction = model.futTransactions![index];
                                    return ListTile(
                                      title: Text(
                                        transaction.createdAt.toString(),
                                        style: const MultiLineStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        transaction.reason,
                                        style: const MultiLineStyle(color: Colors.white),
                                      ),
                                      trailing: Text(
                                        transaction.coinAmount.toString(),
                                        style: const BoldMultiLineStyle(color: Colors.white),
                                      ),
                                    );
                                  }),
                            ),
                            Center(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryYellowColor,
                                ),
                                child: const Text(
                                  '取引履歴をもっとみる',
                                  style: TextStyle(color: primaryYellowColor),
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FUTTransactionHistoryPage(
                                        futTransactions: model.futTransactions!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          '取引履歴はありません',
                          style: MultiLineStyle(color: Colors.white),
                        ),
                const SizedBox(height: 48),
                IntrinsicWidth(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: primaryYellowColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'FUTを使う',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ProductWidget(
                  name: '2025カレンダー',
                  imagePath: 'salon_app_commons/resources/calendar2025.png',
                  reason: FUTReasons.exchangeTo2025Calendar,
                  futAmount: -FUTReasons.exchangeTo2025Calendar.futAmount!,
                ),
                const SizedBox(height: 64),
                ProductWidget(
                  name: 'Tシャツ',
                  imagePath: 'salon_app_commons/resources/flutter_t.jpg',
                  reason: FUTReasons.exchangeToTShirt,
                  futAmount: -FUTReasons.exchangeToTShirt.futAmount!,
                ),
                const SizedBox(height: 64),
                ProductWidget(
                  name: 'Flutter本',
                  imagePath: 'salon_app_commons/resources/zerokara.jpeg',
                  reason: FUTReasons.exchangeToBook,
                  futAmount: -FUTReasons.exchangeToBook.futAmount!,
                ),
                const SizedBox(height: 64),
                ProductWidget(
                  name: 'マグカップ',
                  imagePath: 'salon_app_commons/resources/mag.jpg',
                  reason: FUTReasons.exchangeToMagCup,
                  futAmount: -FUTReasons.exchangeToMagCup.futAmount!,
                ),
                const SizedBox(height: 64),
                ProductWidget(
                  name: 'ステッカー',
                  imagePath: 'salon_app_commons/resources/flutteruniv_sticker.jpg',
                  reason: FUTReasons.exchangeToSticker,
                  futAmount: -FUTReasons.exchangeToSticker.futAmount!,
                ),
                const SizedBox(height: 64),
                const Icon(
                  Icons.redeem,
                  color: Colors.white,
                  size: 100,
                ),
                const Text(
                  'ほかのメンバーにギフトすることも出来ます',
                  style: MultiLineStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Center(
                  child: RoundedMoveButton(
                    isMobile: true,
                    isLoading: model.isLoading,
                    title: 'FUTをギフトする',
                    onTap: () => onTapGift?.call(context),
                  ),
                ),
                const SizedBox(height: 64),
                const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 100,
                ),
                const Text(
                  'FUTを使ってメンターをお願いすることも出来ます',
                  style: MultiLineStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Center(
                  child: RoundedMoveButton(
                    isMobile: true,
                    isLoading: model.isLoading,
                    title: 'メンターを探す',
                    onTap: onTapMentor,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            );
          }),
        );
      },
    );
  }
}

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.reason,
    required this.futAmount,
  }) : super(key: key);

  final String name;
  final String imagePath;
  final FUTReasons reason;
  final int futAmount;

  @override
  Widget build(BuildContext context) {
    final model = context.read<MyFUTModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 160,
          child: Image.asset(imagePath),
        ),
        const SizedBox(height: 8),
        Text(
          '$name ${futAmount}FUT',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 16),
        Center(
          child: RoundedMoveButton(
            isMobile: true,
            isLoading: model.isLoading,
            title: '$nameと交換する',
            onTap: () async {
              final isYes = await showConfirmDialog(
                context,
                '${futAmount}FUTを消費して$nameと交換を申請してよろしいですか？',
              );

              if (isYes) {
                model.startLoading();

                try {
                  await model.exchangeToGoods(reason);
                  await model.fetchUserAndTransaction();
                  showTextDialog(
                    context,
                    '$nameとの交換申請が完了しました🎉'
                    '運営からのslackでのご連絡をお待ちください',
                  );
                } catch (e) {
                  showErrorDialogAndInquiryChat(context, e);
                } finally {
                  model.endLoading();
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
