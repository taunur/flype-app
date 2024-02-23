import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/app_fonts.dart';
import 'package:flype/data/model/detail_story_model.dart';
import 'package:flype/data/provider/auth_provider.dart';
import 'package:flype/data/provider/detail_story_provider.dart';
import 'package:flype/data/utils/result_state.dart';
import 'package:flype/widgets/error_widget.dart';
import 'package:flype/widgets/loading_widget.dart';
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
        backgroundColor: AppColor.background,
        centerTitle: true,
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.white,
          ),
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
  final formatter =
      DateFormat.yMMMMd('id').add_jm().format(detailStory.createdAt!);

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
                      color: AppColor.white,
                      fontWeight: regular,
                      fontSize: 16,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              detailStory.name!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColor.white,
                    fontWeight: regular,
                    fontSize: 16,
                  ),
            ),
          ],
        ),

        // Tampilkan gambar jika photoUrl tidak null
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
                  .shrink(), // Jika photoUrl null, widget ini tidak akan ditampilkan
        ),

        const SizedBox(height: 24),

        RichText(
          text: TextSpan(
            children: [
              // Nama
              TextSpan(
                text: detailStory.name ?? '',
                style: whiteTextstyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
              // Spasi antara nama dan deskripsi
              const TextSpan(text: ' '),
              // Deskripsi
              TextSpan(
                text: detailStory.description ?? '',
                style: whiteTextstyle.copyWith(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Tampilkan tanggal pembuatan
        Text(
          'Created at : $formatter',
          style: whiteTextstyle,
        ),

        const SizedBox(height: 6),

        // Tampilkan lokasi (latitude dan longitude)
        Text(
          'Location : ${detailStory.lat ?? ''}, ${detailStory.lon ?? ''}',
          style: whiteTextstyle,
        ),
      ],
    ),
  );
}
