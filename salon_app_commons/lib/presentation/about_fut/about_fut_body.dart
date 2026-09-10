import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

//ローディング画面
class AboutFUTBody extends StatelessWidget {
  const AboutFUTBody({
    Key? key,
    required this.onTapAdButton,
    required this.onTapTimesInput,
    required this.onTapInvite,
  }) : super(key: key);
  final void Function()? onTapAdButton;
  final void Function()? onTapTimesInput;
  final void Function()? onTapInvite;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'How to get FUT',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 45,
                      color: Colors.white,
                    ),
              ),
              Text(
                'FUTを得る方法',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                '共同開発で入賞',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const Text(
                '管理者から付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '''
1位
${FUTReasons.jointDev1st.futAmount}FUT

2位
${FUTReasons.jointDev2nd.futAmount}FUT

3位
${FUTReasons.jointDev3rd.futAmount}FUT

4位
${FUTReasons.jointDev4th.futAmount}FUT

5位以下
${FUTReasons.jointDev5th.futAmount}FUT
                    ''',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                '共同勉強会',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                '発表',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'slack上申請ページより付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              Text(
                '${FUTReasons.presentationStudyMeeting.futAmount}FUT',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              const Text(
                '参加',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              Text(
                '${FUTReasons.joinStudyMeeting.futAmount}FUT',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                '個人開発発表会',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                '発表',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'slack上申請ページより付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              Text(
                '${FUTReasons.presentationPersonalDevMeeting.futAmount}FUT',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              const Text(
                '参加',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              Text(
                '${FUTReasons.joinPersonalDevMeeting.futAmount}FUT',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                'オンライン交流会',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '''
参加したら
${FUTReasons.joinPartyMeeting.futAmount}FUT
                    ''',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                '動画切り抜き',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '${FUTReasons.clipVideo.futAmount}FUT (1動画あたり)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                '広告を見る',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '''
${FUTReasons.viewAd.futAmount}FUT
                ''',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              RoundedMoveButton(
                isMobile: true,
                title: '広告を見てFUTをゲット',
                onTap: onTapAdButton,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                'slackでtimes作成',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '''
${FUTReasons.madeSlackTimes.futAmount}FUT
''',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              RoundedMoveButton(
                isMobile: true,
                title: 'timesボーナスをゲット',
                onTap: onTapTimesInput,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                'メンバー招待',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '''
招待する側
${FUTReasons.invite.futAmount}FUT

招待される側
${FUTReasons.invited.futAmount}FUT
                    ''',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              RoundedMoveButton(
                isMobile: true,
                title: '友人を招待する',
                onTap: onTapInvite,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                '入会時の1on1を担当',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '${FUTReasons.mentor1on1.futAmount}FUT',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                '朝のもくもく会に参加',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '${FUTReasons.joinMorningGather.futAmount}FUT',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 64,
              ),
              const Text(
                '動画にユーザーを付与',
                style: BoldMultiLineStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const Text(
                'システムで自動付与',
                style: MultiLineStyle(
                  color: primaryYellowColor,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '${FUTReasons.addUserToVideo.futAmount}FUT (1動画あたり)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 80, // お問い合わせボタンとかぶるので下の幅は広めにとる
              ),
            ],
          ),
        ),
      ),
    );
  }
}
