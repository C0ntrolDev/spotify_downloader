import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
        routes: const [HomeRoute(), HistoryRoute()],
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                child,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(150, 0, 0, 0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Theme(
                      data: ThemeData(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: const Color.fromARGB(0, 0, 0, 0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BottomNavigationBar(
                            enableFeedback: false,
                            selectedFontSize: 10,
                            unselectedFontSize: 10,
                            selectedItemColor: onBackgroundPrimaryColor,
                            unselectedItemColor: onBackgroundSecondaryColor,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            currentIndex: tabsRouter.activeIndex,
                            onTap: (index) => tabsRouter.setActiveIndex(index),
                            items: [
                              BottomNavigationBarItem(
                                  icon: SvgPicture.asset(
                                    'resources/images/svg/bottom_bar/home_icon.svg',
                                    height: 25,
                                    width: 25,
                                    colorFilter: const ColorFilter.mode(onBackgroundSecondaryColor, BlendMode.srcIn),
                                  ),
                                  activeIcon: SvgPicture.asset(
                                    'resources/images/svg/bottom_bar/home_icon_active.svg',
                                    height: 25,
                                    width: 25,
                                    colorFilter: const ColorFilter.mode(onBackgroundPrimaryColor, BlendMode.srcIn),
                                  ),
                                  label: 'Главная'),
                              BottomNavigationBarItem(
                                  icon: SvgPicture.asset(
                                    'resources/images/svg/bottom_bar/history_icon.svg',
                                    height: 25,
                                    width: 25,
                                    colorFilter: const ColorFilter.mode(onBackgroundSecondaryColor, BlendMode.srcIn),
                                  ),
                                  activeIcon: SvgPicture.asset(
                                    'resources/images/svg/bottom_bar/history_icon_active.svg',
                                    height: 25,
                                    width: 25,
                                    colorFilter: const ColorFilter.mode(onBackgroundPrimaryColor, BlendMode.srcIn),
                                  ),
                                  label: 'История'),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
