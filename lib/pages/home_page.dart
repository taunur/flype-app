import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
// import 'package:flype/data/model/list_story_model.dart';
import 'package:flype/data/provider/story_provider.dart';
import 'package:flype/data/utils/result_state.dart';
import 'package:flype/widgets/error_widget.dart';
import 'package:flype/widgets/loading_widget.dart';
import 'package:flype/widgets/story_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dapatkan instance dari StoryProvider
    // Provider.of<StoryProvider>(context).getRestaurant();

    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        automaticallyImplyLeading: false,
        title: const Text(
          'FLYPE',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<StoryProvider>(
        builder: (context, stories, _) {
          // Periksa jika data sudah diambil
          if (stories.state == ResultState.loading) {
            return const Loading();
          } else if (stories.state == ResultState.hasData) {
            return ListView.builder(
              itemCount: stories.allStories.length,
              itemBuilder: (context, index) {
                // Gunakan data dari provider.stories
                return StoryListItem(story: stories.allStories[index]);
              },
            );
          } else if (stories.state == ResultState.noData) {
            return ErrorMessageWidget(message: stories.message);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
