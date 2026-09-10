import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:salon_app_commons/widget/comment_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class VideoDetailPage extends StatelessWidget {
  static String route(String chapterId, String contentId) {
    return '/materials/$chapterId/$contentId';
  }

  final String chapterId; // 質問zoomか勉強会動画かイラストか
  final String contentId; // コンテンツ１個１個のid
  final List<Video>? extraVideos;
  final PreferredSizeWidget appBar;

  const VideoDetailPage(
    this.appBar,
    this.chapterId,
    this.contentId,
    this.extraVideos, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoDetailModel>(
      create: (_) => VideoDetailModel(
        chapterId,
        contentId,
        extraVideos,
      )..init(context),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: primaryNavyColor,
          appBar: appBar,
          body: Consumer<VideoDetailModel>(builder: (context, model, child) {
            final myUser = model.myUser;
            final videoUser = model.videoUser;
            final isPaidPlan = model.isPaidPlan;
            final materials = model.extraVideos;

            if (isPaidPlan == null || materials == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else {
              return ResponsiveBuilder(builder: (context, sizingInformation) {
                final screenType = sizingInformation.deviceScreenType;
                switch (sizingInformation.deviceScreenType) {
                  case DeviceScreenType.desktop:
                    // PCでみた時
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1750),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: VideoMediaWidget(),
                                  ),
                                  model.isLoading
                                      ? const FlutterUnivLoadingIndicator(
                                          backgroundColor: themeNavy,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            bottom: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const DescriptionCard(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  left: 16,
                                                ),
                                                child: UserCard(videoUser),
                                              ),
                                              const SizedBox(height: 8),
                                              const ButtonCard(),
                                              if (myUser != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 32),
                                                  child: CommentsWidget(
                                                    user: myUser,
                                                    isMobile: screenType ==
                                                        DeviceScreenType.mobile,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MenuCard(
                                screenType: screenType,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  default:
                    // モバイル, タブレット
                    return Column(
                      children: [
                        const VideoMediaWidget(),
                        Expanded(
                          child: model.isLoading
                              ? const FlutterUnivLoadingIndicator(
                                  backgroundColor: themeNavy,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const DescriptionCard(),
                                        UserCard(videoUser),
                                        const SizedBox(height: 8),
                                        const ButtonCard(),
                                        if (myUser != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: .0),
                                            child: CommentsWidget(
                                              user: myUser,
                                              isMobile: screenType ==
                                                  DeviceScreenType.mobile,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    );
                }
              });
            }
          }),
        );
      },
    );
  }
}

class VideoMediaWidget extends StatelessWidget {
  const VideoMediaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<VideoDetailModel>();
    if (model.isLoading) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: model.vimeoController != null
            ? Chewie(controller: model.vimeoController!)
            : Container(
                color: Colors.black,
              ),
      );
    }
  }
}

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<VideoDetailModel>();
    final selectedVideo = model.selectedVideo;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedVideo?.title ?? '',
            style: const BoldMultiLineStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          if (selectedVideo?.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Linkify(
                onOpen: (link) async {
                  await URLUtils.launch(urlString: link.url);
                },
                text: selectedVideo?.description ?? '',
                style: const MultiLineStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User? user;
  final Color color;

  const UserCard(
    this.user, {
    Key? key,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = this.user;
    return IntrinsicWidth(
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              // 画面遷移の時は動画を止めたい
              final model = context.read<VideoDetailModel?>();
              model?.vimeoController?.pause();

              if (user == null) {
                // 追加画面へ
                final member = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MembersSearchPage(
                      shouldShowMyself: true,
                    ),
                  ),
                );
                final isYes = await showConfirmDialog(
                  context,
                  '${member.nickname}をこの動画に付与しますか？',
                );

                if (isYes) {
                  final model = context.read<VideoDetailModel>();

                  try {
                    await model.addUserToVideo(member);

                    await showTextDialog(
                      context,
                      '${member.nickname}をこの動画に追加しました。',
                    );
                    model.loadVideo();
                  } catch (e) {
                    await showTextDialog(
                      context,
                      'エラーが発生しました。時間をおいて再度お試しください。',
                    );
                  }
                }
              } else {
                context.push(MemberDetailPage.route(user.nickname!));
              }
            },
            child: Row(
              children: [
                SizedBox(
                  height: 32,
                  width: 32,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32 / 2),
                    child: user?.photoUrl != null
                        ? FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: user!.photoUrl!,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              // フィードのエラーハンドリング
                              return Image.asset(
                                'resources/img_photo_default.png',
                              );
                            },
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 32 / 2,
                            child: Icon(
                              Icons.person,
                              size: 20,
                              color: primaryNavyColor,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  user?.nickname ?? 'ユーザー追加',
                  style: BoldMultiLineStyle(
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ButtonCard extends StatelessWidget {
  const ButtonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<VideoDetailModel>();
    final selectedVideo = model.selectedVideo;

    if (selectedVideo == null) {
      return const SizedBox();
    }
    final liked = model.likedIds.contains(selectedVideo.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 16,
        ),
        if (model.isLoadingLikeCount)
          const SizedBox(
            width: 60,
            child: FlutterUnivLoadingIndicator(
              backgroundColor: themeNavy,
              width: 30,
            ),
          )
        else
          SizedBox(
            width: 60,
            child: Row(
              children: [
                Tooltip(
                  message: '動画を高評価する',
                  child: IconButton(
                    onPressed: () async {
                      if (liked) {
                        //いいねを消去する時の処理
                        final isYes =
                            await showConfirmDialog(context, 'いいねを取り消しますか？');
                        if (isYes) {
                          model.startLoadingLikeCount();
                          await model.removeLiked(selectedVideo.id);
                        }
                      } else {
                        //いいねをした時の処理
                        model.confettiController.play();
                        model.startLoadingLikeCount();
                        await model.addLiked(selectedVideo.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('いいねあざす！！'),
                            backgroundColor: primaryYellowColor,
                          ),
                        );
                      }
                      await model.checkLikeCountAgain(selectedVideo.id);
                      model.endLoadingLikeCount();
                    },
                    icon: Icon(
                      Icons.thumb_up,
                      color: liked ? primaryYellowColor : Colors.white,
                    ),
                  ),
                ),
                Text(
                  '${selectedVideo.likeCount}',
                  style: TextStyle(
                    color: liked ? primaryYellowColor : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ConfettiWidget(
          confettiController: model.confettiController,
          blastDirection: -pi / 4,
          emissionFrequency: 0.1,
        ),
        if (selectedVideo.link != null)
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Tooltip(
                message: 'vimeoで見る',
                child: IconButton(
                  onPressed: () {
                    // vimeoに飛ぶ
                    URLUtils.launch(
                      urlString: selectedVideo.link!,
                      shouldOpenNewTab: true,
                    );
                  },
                  icon: const Icon(
                    WebSymbols.vimeo_rect,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(
          width: 16,
        ),
        Tooltip(
          message: 'クリップボードにコピー',
          child: IconButton(
            onPressed: () async {
              // コピペ機能
              String url = URLUtils.getCurrentUrl();

              // モバイルだとcurrentURL取れないのでurl作る
              if (isMobile) {
                url =
                    'https://flutteruniv.com/materials/${model.originalChapterId}/${model.selectedVideo?.id}';
              }
              await Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('クリップボードにコピーしました！'),
                  backgroundColor: primaryYellowColor,
                ),
              );
              await Future.delayed(const Duration(milliseconds: 200));
              HapticFeedback.mediumImpact();
            },
            icon: const Icon(
              Icons.copy,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class MenuCard extends StatelessWidget {
  final DeviceScreenType screenType;

  const MenuCard({
    Key? key,
    required this.screenType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<VideoDetailModel>();
    final searchWord = model.searchController.text;
    final searchedVideos = model.searchVideoByName(searchWord: searchWord);
    final bool isDesktop = screenType == DeviceScreenType.desktop;
    return SizedBox(
      width: isDesktop ? 360 : double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: model.searchController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '検索する',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Card(
              color: Colors.white.withOpacity(0.5),
              child: ListView(
                physics: isDesktop
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                shrinkWrap: !isDesktop,
                children: searchedVideos.map((material) {
                  final isSelected = model.selectedVideo == material;
                  return InkWell(
                    onTap: () async {
                      await model.selectVideoFromMenu(material);
                    },
                    child: Container(
                      color: isSelected ? Colors.white.withOpacity(0.7) : null,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 90,
                              child: Image.network(material.image),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    material.title,
                                    style: isSelected
                                        ? const BoldMultiLineStyle(fontSize: 12)
                                        : const MultiLineStyle(fontSize: 12),
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Text(
                                    material.createdAt.formatYMDW,
                                    style: const MultiLineStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
