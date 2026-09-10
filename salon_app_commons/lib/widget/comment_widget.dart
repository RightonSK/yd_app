import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:salon_app_commons/domain/comment.dart';
import 'package:salon_app_commons/salon_app_commons.dart';
import 'package:transparent_image/transparent_image.dart';

class CommentsWidget extends StatelessWidget {
  final User user;
  final bool isMobile;

  const CommentsWidget({
    super.key,
    required this.user,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return InkWell(
        child: const CommentMobileCushionWidget(),
        onTap: () {
          // 下から出てくる
          showBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            )),
            context: context,
            builder: (context) {
              return Container(
                height: 500,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: const BoxDecoration(
                            color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'コメント',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 32,
                              ))
                        ],
                      ),
                    ),
                    const Divider(height: 2),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: CommentListWidget(),
                      ),
                    ),
                    const Divider(height: 2),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: _TextFromFieldWidget(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          );
        },
      );
    } else {
      // PCとタブレットはそのまま出す
      return Column(
        children: const [
          _TextFromFieldWidget(
            color: Colors.white,
          ),
          SizedBox(height: 8),
          CommentListWidget(
            textColor: Colors.white,
          ),
        ],
      );
    }
  }
}

class CommentMobileCushionWidget extends StatelessWidget {
  const CommentMobileCushionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'コメントする',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentListWidget extends StatelessWidget {
  const CommentListWidget({
    Key? key,
    this.textColor = Colors.black,
  }) : super(key: key);

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<VideoDetailModel>();
    final commentList = model.videoCommentList;

    if (commentList == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: FlutterUnivLoadingIndicator(
            backgroundColor: primaryNavyColor,
          ),
        ),
      );
    }

    return commentList.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'コメントがありません',
              style: MultiLineStyle(
                color: textColor,
              ),
            ),
          )
        : ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: commentList
                .map((comment) => _CommentCardWidget(
                      videoComment: comment,
                      textColor: textColor,
                    ))
                .toList(),
          );
  }
}

class _CommentCardWidget extends StatelessWidget {
  const _CommentCardWidget({
    required this.videoComment,
    this.textColor = Colors.black,
  });
  final VideoComment videoComment;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final model = context.read<VideoDetailModel>();
    final userId = model.myUser!.id;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            maxRadius: 20,
            backgroundImage: videoComment.photoURL != null
                ? NetworkImage(videoComment.photoURL!)
                : const NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png',
                  ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      videoComment.name ?? '名無し',
                      style: MultiLineStyle(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      videoComment.createdAt.toDate().getHowLongTimeAgoString(),
                      style: MultiLineStyle(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                SelectableLinkify(
                  text: videoComment.commentText!,
                  style: MultiLineStyle(
                    color: textColor,
                  ),
                  linkStyle: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                  onOpen: (link) async {
                    await URLUtils.launch(urlString: link.url);
                  },
                ),
              ],
            ),
          ),
          if (userId == videoComment.userId)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    if (await showConfirmDialog(context, 'このコメントを削除しますか？')) {
                      final model = context.read<VideoDetailModel>();
                      await model.deleteComment(videoComment.id);
                    }
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TextFromFieldWidget extends StatefulWidget {
  const _TextFromFieldWidget({
    Key? key,
    this.color = primaryNavyColor,
  }) : super(key: key);

  final Color color;

  @override
  State<_TextFromFieldWidget> createState() => _TextFromFieldWidgetState();
}

class _TextFromFieldWidgetState extends State<_TextFromFieldWidget> {
  final TextEditingController _controller = TextEditingController();
  final double photoSize = 30;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<VideoDetailModel>();
    final photoUrl = model.myUser?.photoUrl;
    final noImage = CircleAvatar(
      backgroundColor: widget.color,
      radius: photoSize / 2,
      child: Icon(
        Icons.person,
        size: photoSize / 2,
        color: widget.color == Colors.white ? primaryNavyColor : Colors.white,
      ),
    );
    return Row(
      children: [
        SizedBox(
          height: photoSize,
          width: photoSize,
          child: photoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(photoSize),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: photoUrl,
                    fit: BoxFit.fitHeight,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return noImage;
                    },
                  ),
                )
              : noImage,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: CommonTextFormField(
            hintText: 'コメントを追加..',
            controller: _controller,
            onFieldSubmitted: _controller.text.isNotEmpty
                ? (text) async {
                    await _submit();
                  }
                : null,
          ),
        ),
        IconButton(
            onPressed: _controller.text.isNotEmpty
                ? () async {
                    await _submit();
                  }
                : null,
            icon: Icon(
              Icons.send,
              color: widget.color,
            ))
      ],
    );
  }

  Future _submit() async {
    final model = context.read<VideoDetailModel>();
    final text = _controller.text;
    _controller.clear();
    await model.addComment(text);
    setState(() {});
  }
}
