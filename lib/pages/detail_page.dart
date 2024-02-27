import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flype/common/app_fonts.dart';
import 'package:flype/common/export.dart';
import 'package:flype/data/model/detail_story_model.dart';
import 'package:flype/data/provider/auth_provider.dart';
import 'package:flype/data/provider/detail_story_provider.dart';
import 'package:flype/data/utils/result_state.dart';
import 'package:flype/widgets/error_widget.dart';
import 'package:flype/widgets/loading_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final String storyId;

  const DetailPage({
    super.key,
    required this.storyId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authToken =
          Provider.of<AuthProvider>(context, listen: false).user.token;
      Provider.of<DetailStoryProvider>(context, listen: false).getStoryById(
        widget.storyId,
        authToken.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.detail,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/navBar');
          },
        ),
      ),
      body: Consumer<DetailStoryProvider>(
        builder: (context, detailStory, child) {
          switch (detailStory.state) {
            case ResultState.loading:
              return const Loading();
            case ResultState.hasData:
              return _buildDetails(
                context,
                detailStory.detailStory!.story,
              );
            case ResultState.error:
              return ErrorMessageWidget(
                message: detailStory.message,
              );
            default:
              return const Text('Unexpected state');
          }
        },
      ),
    );
  }
}

/// Detail Content
Widget _buildDetails(BuildContext context, DetailStory detailStory) {
  final formatter = DateFormat('hh:mm a, dd MMMM yyyy', 'id_ID')
      .format(detailStory.createdAt!);

  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.primaries[Random().nextInt(
                Colors.primaries.length,
              )],
              radius: 18,
              child: Text(
                detailStory.name![0].toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: regular,
                      fontSize: 16,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              detailStory.name!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: regular,
                    fontSize: 16,
                  ),
            ),
          ],
        ),

        /// Tampilkan gambar jika photoUrl tidak null
        Container(
          margin: const EdgeInsets.only(top: 10),
          alignment: Alignment.center,
          child: detailStory.photoUrl != null
              ? Image.network(
                  detailStory.photoUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : const SizedBox
                  .shrink(),
        ),

        const SizedBox(height: 24),

        RichText(
          text: TextSpan(
            children: [
              /// Nama
              TextSpan(
                text: detailStory.name ?? '',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: bold,
                      fontSize: 16,
                    ),
              ),
              /// Spasi antara nama dan deskripsi
              const TextSpan(text: ' '),
              /// Deskripsi
              TextSpan(
                text: detailStory.description ?? '',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: regular,
                      fontSize: 15,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        /// Tampilkan tanggal pembuatan
        Text(
          '${AppLocalizations.of(context)!.createdAt} $formatter',
        ),

        const SizedBox(height: 6),

        /// Tampilkan lokasi (latitude dan longitude)
        Text(
          '${AppLocalizations.of(context)!.location} ${detailStory.lat ?? ''}, ${detailStory.lon ?? ''}',
        ),
      ],
    ),
  );
}
