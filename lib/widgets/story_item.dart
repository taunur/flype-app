import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/app_fonts.dart';
import 'package:flype/data/model/list_story_model.dart';
import 'package:flype/data/provider/datetime_provider.dart';
import 'package:provider/provider.dart';

class StoryListItem extends StatefulWidget {
  final ListStory story;

  const StoryListItem({Key? key, required this.story}) : super(key: key);

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
          color: AppColor.background,
          borderRadius: BorderRadius.circular(16.0),
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
                          widget.story.name[0].toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: AppColor.white,
                                    fontWeight: regular,
                                    fontSize: 16,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.story.name,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppColor.white,
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
                      color: AppColor.white,
                    ),
                    color: AppColor.background,
                    offset: const Offset(0, 50),
                    onSelected: (value) {
                      switch (value) {
                        case 'details':
                          // Navigator.pushReplacementNamed(
                          //     context, AppRoute.getStarted);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'details',
                        child: Text(
                          'Detail Story',
                          style: TextStyle(color: AppColor.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: widget.story.photoUrl,
                fadeOutDuration: const Duration(seconds: 2),
                fadeInDuration: const Duration(seconds: 2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    widget.story.description,
                    maxLines: _expanded ? null : 1,
                    overflow: _expanded ? null : TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  // Tampilkan "Read more" hanya jika deskripsi tidak sepenuhnya diperpanjang
                  if (widget.story.description.length > 20)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      child: Text(
                        _expanded ? 'Show less' : 'Read more',
                        style: const TextStyle(color: AppColor.blue),
                      ),
                    ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Created At: $formattedTime',
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
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
