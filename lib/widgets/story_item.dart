import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/app_fonts.dart';
import 'package:flype/common/export.dart';
import 'package:flype/data/model/list_story_model.dart';
import 'package:flype/data/provider/datetime_provider.dart';
import 'package:flype/routes/config_go_router.dart';
import 'package:provider/provider.dart';

class StoryListItem extends StatefulWidget {
  final ListStory story;

  const StoryListItem({
    Key? key,
    required this.story,
  }) : super(key: key);

  @override
  State<StoryListItem> createState() => _StoryListItemState();
}

class _StoryListItemState extends State<StoryListItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final storyTimeProvider =
        Provider.of<StoryTimeProvider>(context, listen: false);
    final formattedTime = storyTimeProvider.formatCreatedAt(widget.story);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.primaries[Random().nextInt(
                          Colors.primaries.length,
                        )],
                        radius: 18,
                        child: Text(
                          widget.story.name![0].toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                fontWeight: regular,
                                fontSize: 16,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.story.name!,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: regular,
                                  fontSize: 16,
                                ),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(
                      Icons.more_vert,
                    ),
                    offset: const Offset(0, 50),
                    onSelected: (value) {
                      switch (value) {
                        case 'details':
                          goRouter.go("/navBar/stories/${widget.story.id}");
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'details',
                        child:
                            Text(AppLocalizations.of(context)!.detailStory),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: widget.story.photoUrl!,
                fadeOutDuration: const Duration(seconds: 2),
                fadeInDuration: const Duration(seconds: 2),
                height: 300,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    widget.story.description!,
                    maxLines: _expanded ? null : 1,
                    overflow: _expanded ? null : TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  // Tampilkan "Read more" hanya jika deskripsi tidak sepenuhnya diperpanjang
                  if (widget.story.description!.length > 30)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      child: Text(
                        _expanded ? 'Show less' : 'Read more',
                        style: const TextStyle(color: AppColor.variantBlue),
                      ),
                    ),
                  Text(
                    '${AppLocalizations.of(context)!.createdAt} $formattedTime',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
