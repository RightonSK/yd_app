import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

import 'rewards_model.dart';

class RewardsPage extends StatelessWidget {
  static const String route = '/rewards';

  const RewardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewardsModel>(
      create: (_) => RewardsModel()..init(context),
      builder: (context, child) {
        return Consumer<RewardsModel>(builder: (context, model, child) {
          final events = model.rewards;

          if (events == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          return Scaffold(
            appBar: const LogoAppBar(
              isLogin: true,
              isUnderRegister: false,
            ),
            body: GridView(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 16 / 14,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              children: events.map((e) => RewardCard(e)).toList(),
            ),
          );
        });
      },
    );
  }
}

class RewardCard extends StatelessWidget {
  const RewardCard(
    this.reward, {
    Key? key,
  }) : super(key: key);

  final Reward reward;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final isYes = await showActionConfirmDialog(
          context,
          SizedBox(
            width: 500,
            height: 440,
            child: _RewardCardColumn(
              reward,
              imageHeight: 100,
            ),
          ),
          reward.ctaText,
          'キャンセル',
        );

        if (isYes) {
          URLUtils.launch(urlString: reward.url);
        }
      },
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: _RewardCardColumn(
          reward,
          maxLines: 3,
          absorbing: true,
          descriptionFontSize: 11,
        ),
      ),
    );
  }
}

class _RewardCardColumn extends StatelessWidget {
  const _RewardCardColumn(
    this.reward, {
    Key? key,
    this.maxLines,
    this.absorbing = false,
    this.descriptionFontSize = 14,
    this.imageHeight,
  }) : super(key: key);

  final Reward reward;
  final int? maxLines;
  final bool absorbing;
  final double descriptionFontSize;
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: imageHeight,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                reward.imageURL,
                width: double.infinity,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: const BoldMultiLineStyle(
                    fontSize: 20,
                  ),
                ),
                AbsorbPointer(
                  absorbing: absorbing,
                  child: SelectableLinkify(
                    onOpen: (link) async {
                      await URLUtils.launch(urlString: link.url);
                    },
                    text: reward.description,
                    style: MultiLineStyle(
                      fontSize: descriptionFontSize,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: maxLines,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
