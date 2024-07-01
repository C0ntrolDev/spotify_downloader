import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager.dart';
import 'package:spotify_downloader/core/permissions/requiring_permission_services_initializer.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:spotify_downloader/features/presentation/permissions_dialog/view/permissions_dialog.dart';
import 'package:spotify_downloader/generated/l10n.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with AutoRouteAwareStateMixin {
  final PermissionsManager _permissionsManager = injector.get<PermissionsManager>();
  final RequiringPermissionServicesInitializer _requiringPermissionServicesInitializer =
      injector.get<RequiringPermissionServicesInitializer>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future(() async {
        if (!(await _permissionsManager.isPermissionsGranted()) && context.mounted) {
          //idk i checked it in previous line
          // ignore: use_build_context_synchronously
          showPermissonsDialog(context, () async {
            final isPermissionsGranted = await _permissionsManager.requestPermissions();
            await _requiringPermissionServicesInitializer.init();
            return isPermissionsGranted;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
        routes: const [HomeRoute(), HistoryRoute()],
        navigatorObservers: () => [AutoRouteObserver()],
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                child,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        alignment: Alignment.bottomCenter,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(230, 0, 0, 0)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        child: Theme(
                          data: ThemeData(
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: const Color.fromARGB(0, 0, 0, 0),
                          ),
                          child: CustomNavigationBar(
                              iconSize: const Size(25, 25),
                              labelFontSize: 10,
                              selectedItemColor: onBackgroundPrimaryColor,
                              unselectedItemColor: onBackgroundSecondaryColor,
                              selectingItemColor: onBackgroundThirdRateColor,
                              selectingSize: 0.9,
                              animationDuration: const Duration(milliseconds: 50),
                              currentIndex: tabsRouter.activeIndex,
                              onTap: (index) => tabsRouter.setActiveIndex(index),
                              items: [
                                CustomNavigationBarItem(
                                    svgIconPath: 'resources/images/svg/bottom_bar/home_icon.svg',
                                    svgActiveIconPath: 'resources/images/svg/bottom_bar/home_icon_active.svg',
                                    label: S.of(context).main),
                                CustomNavigationBarItem(
                                    svgIconPath: 'resources/images/svg/bottom_bar/history_icon.svg',
                                    svgActiveIconPath: 'resources/images/svg/bottom_bar/history_icon_active.svg',
                                    label: S.of(context).history),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
