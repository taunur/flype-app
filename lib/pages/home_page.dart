import 'package:flutter/material.dart';
import 'package:flype/common/export.dart';
import 'package:flype/data/provider/auth_provider.dart';
import 'package:flype/data/provider/story_provider.dart';
import 'package:flype/data/utils/result_state.dart';
import 'package:flype/widgets/error_widget.dart';
import 'package:flype/widgets/loading_widget.dart';
import 'package:flype/widgets/story_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authToken =
          Provider.of<AuthProvider>(context, listen: false).user.token;
      Provider.of<StoryProvider>(context, listen: false)
          .getStory(authToken.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.titleAppBar,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<StoryProvider>().refresh(),
        child: Consumer<StoryProvider>(
          builder: (context, stories, _) {
            if (stories.state == ResultState.loading) {
              return const Loading();
            } else if (stories.state == ResultState.hasData) {
              return ListView.builder(
                itemCount: stories.allStories.length,
                itemBuilder: (context, index) {
                  return StoryListItem(
                    story: stories.allStories[index],
                  );
                },
              );
            } else if (stories.state == ResultState.noData) {
              return ErrorMessageWidget(message: stories.message);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
