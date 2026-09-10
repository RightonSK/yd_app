import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/presentation/lp/lp_cta_github_button.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'lp_new_users_widget.dart';

class CTAButton extends StatelessWidget {
  const CTAButton({
    Key? key,
    required this.onTappedGitHubButton,
    required this.onTappedAdmissionButton,
  }) : super(key: key);
  final void Function() onTappedGitHubButton;
  final void Function() onTappedAdmissionButton;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<LPModel>();
    final isMaintenanceMode = model.isMaintenanceMode;

    return Builder(builder: (context) {
      if (isMaintenanceMode == null) {
        return const FlutterUnivLoadingIndicator();
      }

      if (isMaintenanceMode) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            t.underMaintenance,
            style: const BoldMultiLineStyle(
              color: primaryYellowColor,
              fontSize: 24,
            ),
          ),
        );
      }
      return Column(
        children: [
          GitHubCTAButton(
            onTappedGitHubButton: onTappedGitHubButton,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onTappedAdmissionButton,
            child: Text(
              t.cta,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          const NewUsersWidget(),
        ],
      );
    });
  }
}

extension WachOrNull on BuildContext {
  T? watchOrNull<T>() {
    try {
      return watch<T>();
    } on ProviderNotFoundException catch (_) {
      return null;
    }
  }
}
