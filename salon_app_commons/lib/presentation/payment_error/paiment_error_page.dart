import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'payment_error_model.dart';

class PaymentErrorPage extends StatelessWidget {
  const PaymentErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentErrorModel>(
      create: (_) => PaymentErrorModel(),
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '決済がエラーになっています。デビッドカードの方は残高を確認してください。クレジットカードの方は上限を確認してください。カードの期限切れの方は、以下の『支払い方法を変更する』から正しく決済ができるクレジットカードを登録し直して下さい。決済が正常になるまでしばらく時間がかかります。',
                      style: MultiLineStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Consumer<PaymentErrorModel>(builder: (context, model, child) {
                return Center(
                  child: RoundedActionButton(
                    isLoading: model.isLoading,
                    isMobile: false,
                    title: '支払い方法を\n変更する',
                    textColor: Colors.redAccent,
                    onTap: () async {
                      model.startLoading();

                      try {
                        final baseUrl = URLUtils.getBaseUrl();
                        await StripeRepository()
                            .redirectToCustomerPortal(baseUrl);
                      } catch (e) {
                        showErrorDialogAndInquiryChat(context, e);
                      } finally {
                        model.endLoading();
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
