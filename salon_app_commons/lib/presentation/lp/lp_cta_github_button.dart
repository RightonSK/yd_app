import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class GitHubCTAButton extends StatelessWidget {
  const GitHubCTAButton({
    Key? key,
    required this.onTappedGitHubButton,
  }) : super(key: key);
  final void Function() onTappedGitHubButton;

  @override
  Widget build(BuildContext context) {
    final model = context.watchOrNull<LPModel>();
    final isMobile = model?.isMobile;
    final isLoading = model?.isLoadingForGithub;
    return RoundedMoveButton(
      onTap: onTappedGitHubButton,
      isMobile: isMobile ?? true,
      isLoading: isLoading ?? false,
      textColor: githubBlackColor,
      iconData: FontAwesome5.github,
      title: t.cta_github,
    );
  }
}
