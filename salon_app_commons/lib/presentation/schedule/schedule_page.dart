import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class SchedulePage extends StatefulWidget {
  static const String route = '/schedule';

  const SchedulePage({
    super.key,
    this.appBar,
  });

  final PreferredSizeWidget? appBar;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool canAccessCalendly = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    try {
      canAccessCalendly = await PermissionUtils.hasCalendlyPermission();
    } catch (e) {
      logger.e('Failed to check Calendly permission: $e');
      canAccessCalendly = false;
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.appBar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '【2025年6月までの修行プランの方向け】\nkboyへの質問zoomの予約は以下のリンクから',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (canAccessCalendly) 
                      const CalendlyLinkButton()
                    else
                      const Text(
                        '修行プラン以上のプランが必要です',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class CalendlyLinkButton extends StatelessWidget {
  const CalendlyLinkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        const calendlyUrl = 'https://calendly.com/kboy/flutteruniv_question';
        URLUtils.launch(urlString: calendlyUrl);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: themeNavy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
      ),
      child: const Text(
        'Calendlyで予約する',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
