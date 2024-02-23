import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
// import 'package:flype/data/model/user_model.dart';
import 'package:flype/data/provider/auth_provider.dart';
// import 'package:flype/data/model/list_story_model.dart';
import 'package:flype/data/provider/story_provider.dart';
import 'package:flype/data/utils/result_state.dart';
import 'package:flype/widgets/error_widget.dart';
import 'package:flype/widgets/loading_widget.dart';
import 'package:flype/widgets/story_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Function(String) onTapped;
  final Function() onLogout;
  const HomePage({super.key, required this.onTapped, required this.onLogout});

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
    final authWatch = context.watch<AuthProvider>();

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
        actions: [
          IconButton(
            icon: authWatch.isLoadingLogout
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(Icons.logout),
            onPressed: () async {
              final authRead = context.read<AuthProvider>();
              final result = await authRead.logout();
              if (result) {
                widget.onLogout();
              }
            },
            tooltip: "Logout",
          ),
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, stories, _) {
          if (stories.state == ResultState.loading) {
            return const Loading();
          } else if (stories.state == ResultState.hasData) {
            return ListView.builder(
              itemCount: stories.allStories.length,
              itemBuilder: (context, index) {
                return StoryListItem(
                  story: stories.allStories[index],
                  onTapped: widget.onTapped,
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
    );
  }
}
