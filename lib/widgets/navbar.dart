import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/pages/home_page.dart';
import 'package:flype/data/provider/page_provider.dart';
import 'package:flype/pages/setting_page.dart';
import 'package:flype/widgets/coming_soon.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool? isLoggedIn;

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    /// addStory
    Widget addStoryButton() {
      return FloatingActionButton(
        onPressed: () {
          context.go('/navBar/addStory');
        },
        backgroundColor: AppColor.blue,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_circle_rounded,
          color: AppColor.white,
        ),
      );
    }

    /// bottom Nav
    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: AppColor.background,
          height: 80,
          shape: const CircularNotchedRectangle(),
          notchMargin: 16,
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.home,
                    color: pageProvider.currentIndex == 0
                        ? AppColor.blue
                        : AppColor.white,
                  ),
                  onPressed: () {
                    setState(() {
                      pageProvider.currentIndex = 0;
                    });
                  }),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: pageProvider.currentIndex == 1
                        ? AppColor.blue
                        : AppColor.white,
                  ),
                  onPressed: () {
                    setState(() {
                      pageProvider.currentIndex = 1;
                    });
                  }),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  icon: Icon(
                    Icons.bookmark_add,
                    color: pageProvider.currentIndex == 2
                        ? AppColor.blue
                        : AppColor.white,
                  ),
                  onPressed: () {
                    setState(() {
                      pageProvider.currentIndex = 2;
                    });
                  }),
              IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: pageProvider.currentIndex == 3
                        ? AppColor.blue
                        : AppColor.white,
                  ),
                  onPressed: () {
                    setState(() {
                      pageProvider.currentIndex = 3;
                    });
                  }),
            ],
          ),
        ),
      );
    }

    /// body
    Widget bodyMain() {
      switch (pageProvider.currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const ComingSoon();
        case 2:
          return const ComingSoon();
        case 3:
          return const SettingPage();
        default:
          return const HomePage();
      }
    }

    return Scaffold(
      floatingActionButton: addStoryButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomNav(),
      body: bodyMain(),
    );
  }
}
