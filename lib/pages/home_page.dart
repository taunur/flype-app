import 'package:flutter/material.dart';
import 'package:flype/animations/loader_animation.dart';
import 'package:flype/common/export.dart';
import 'package:flype/data/provider/auth_provider.dart';
import 'package:flype/data/provider/story_provider.dart';
import 'package:flype/data/utils/result_state.dart';
import 'package:flype/widgets/error_widget.dart';
import 'package:flype/widgets/loading_widget.dart';
import 'package:flype/widgets/story_item.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController loaderController;
  late Animation<double> loaderAnimation;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    /// Get Token
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authToken =
          Provider.of<AuthProvider>(context, listen: false).user.token;
      Provider.of<StoryProvider>(context, listen: false)
          .getStory(authToken.toString());
    });

    /// Custom Pointer
    loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    loaderAnimation = Tween(begin: 1.0, end: 1.4).animate(CurvedAnimation(
      parent: loaderController,
      curve: Curves.easeIn,
    ));
    loaderController.repeat(reverse: true);

    ///  Infinity Scroll
    final storyProvider = context.read<StoryProvider>();
    final authToken =
        Provider.of<AuthProvider>(context, listen: false).user.token;
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storyProvider.pageItems != null) {
          storyProvider.getStory(authToken.toString());
        }
      }
    });
    Future.microtask(() async => storyProvider.getStory(authToken.toString()));
  }

  @override
  void dispose() {
    scrollController.dispose();
    loaderController.dispose();
    super.dispose();
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
              return Center(
                child: AnimatedBuilder(
                  animation: loaderAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: loaderController.status == AnimationStatus.forward
                          ? (math.pi * 2) * loaderController.value
                          : -(math.pi * 2) * loaderController.value,
                      child: CustomPaint(
                        foregroundPainter: LoaderAnimation(
                          radiusRatio: loaderAnimation.value,
                        ),
                        size: const Size(300, 300),
                      ),
                    );
                  },
                ),
              );
            } else if (stories.state == ResultState.hasData) {
              final listStory = stories.allStories;
              return ListView.builder(
                controller: scrollController,
                itemCount:
                    listStory.length + (stories.pageItems != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == listStory.length && stories.pageItems != null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Loading(),
                      ),
                    );
                  }
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
