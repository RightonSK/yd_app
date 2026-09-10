import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

//ローディング画面
class TokushoPage extends StatelessWidget {
  static const String route = '/tokusho';

  static const text = '''
<h3>サービス名</h3>
<p>Flutter大学</p>
<h3>事業者</h3>
<p>株式会社KBOY</p>
<h3>所在地</h3>
<p>東京都渋谷区幡ヶ谷1丁目2番2号京王幡ヶ谷ビルMIDPOINT幡ヶ谷4－41</p>
<h3>電話番号</h3>
<p>07037953029</p>
<h3>メールアドレス</h3>
<p>hello@flutteruniv.com</p>
<h3>運営統括責任者	</h3>
<p>藤川慶</p>
<h3>追加手数料等の追加料金</h3>
<p>特になし</p>
<h3>返金ポリシー</h3>
<p>誤って購入してしまった場合は hello@flutteruniv.com にお問い合わせください。購入後7日未満であれば返金対応が可能です。</p>
<h3>解約</h3>
<p>解約につきましては <a href="https://flutteruniv.com/account_setting">アカウント設定</a>の退会ボタンからお願いします。
<br>システム障害等で退会が機能しない際は、Slack内のkboyへのDMまたは<a href="https://twitter.com/kboy_silvergym">kboyのTwitterのDM</a>にご連絡ください。</p>
<h3>引渡時期</h3>
<p>即時</p>
<h3>受け付け可能な決済手段</h3>
<p>Stripe決済による月額引き落とし</p>
<h3>決済期間</h3>
<p>即時および、翌月以降の同日請求（3ヶ月の場合は3ヶ月ごと、6ヶ月の場合は6ヶ月ごと、年額の場合は1年ごと）</p>
<h3>販売価格</h3>
<p><a href="https://flutteruniv.com/">トップページ</a>の料金一覧に記載（月額2,200円~）</p>
<h3>商品引渡し方法</h3>
<p>Stripeでの初回ご料金お支払い後、システムによりSlackとGitHubへの招待メールが送信されます。<br>また、Flutter大学のアカウントが発行され、アプリ(web、モバイル)が使用可能になります。</p>
''';

  const TokushoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('特定商取引法に基づく表示'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Html(
            data: text,
            onLinkTap: (
              url,
              attributes,
              element,
            ) {
              if (url == null) {
                return;
              }
              URLUtils.launch(urlString: url);
            },
          ),
        ),
      ),
    );
  }
}
