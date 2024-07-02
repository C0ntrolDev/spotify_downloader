import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager.dart';
import 'package:spotify_downloader/core/permissions/requiring_permission_services_initializer.dart';
import 'package:spotify_downloader/features/presentation/main/tools/bottom_navigation_bar_observer.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:spotify_downloader/features/presentation/permissions_dialog/view/permissions_dialog.dart';
import 'package:spotify_downloader/generated/l10n.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PermissionsManager _permissionsManager = injector.get<PermissionsManager>();
  final RequiringPermissionServicesInitializer _requiringPermissionServicesInitializer =
      injector.get<RequiringPermissionServicesInitializer>();

  final List<PageRouteInfo> _bottomNavigationBarRoutes = [const HomeRoute(), const HistoryRoute()];

  int _currentIndexField = 0;
  int get _currentIndex => _currentIndexField;
  set _currentIndex(int newIndex) {
    _currentIndexField = newIndex;
    _currentIndexStreamController.add(newIndex);
  }

  final StreamController<int> _currentIndexStreamController = StreamController.broadcast();

  late final BottomNavigationBarObserver _routeObserver;

  final GlobalKey _bottomNavigationBarKey = GlobalKey();

  double? _bottomNavigationBarHeightField;
  double? get _bottomNavigationBarHeight => _bottomNavigationBarHeightField;
  set _bottomNavigationBarHeight(double? newHeight) {
    _bottomNavigationBarHeightField = newHeight;
    _bottomNavigationBarHeightStreamController.add(newHeight);
  }

  final StreamController<double?> _bottomNavigationBarHeightStreamController = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _routeObserver = BottomNavigationBarObserver(onRouteChanged: _onRouteChanged);

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

  void _onRouteChanged(Route? newRoute) {
    if (newRoute == null || newRoute.data == null) return;
    final indexOfRoute =
        _bottomNavigationBarRoutes.indexWhere((PageRouteInfo route) => route.routeName == newRoute.data!.name);
    if (indexOfRoute != -1) {
      if (_currentIndex != indexOfRoute) {
        _currentIndex = indexOfRoute;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AutoRouter(
            navigatorObservers: () {
              return [_routeObserver];
            },
            builder: (context, content) => StreamBuilder(
                stream: _bottomNavigationBarHeightStreamController.stream,
                builder: (context, value) {
                  return CustomBottomNavigationBarAcessor(height: value.data, child: content);
                }),
          ),
          Builder(builder: (context) {
            _scheduleBottomNavigationBarHeightUpdate();

            return StreamBuilder(
                initialData: 0,
                stream: _currentIndexStreamController.stream,
                builder: (context, value) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          key: _bottomNavigationBarKey,
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
                            child: CustomBottomNavigationBar(
                                iconSize: const Size(25, 25),
                                labelFontSize: 10,
                                selectedItemColor: onBackgroundPrimaryColor,
                                unselectedItemColor: onBackgroundSecondaryColor,
                                selectingItemColor: onBackgroundThirdRateColor,
                                selectingSize: 0.9,
                                animationDuration: const Duration(milliseconds: 50),
                                currentIndex: value.data!,
                                onTap: (index) {
                                  if (AutoRouter.of(context).topRoute.name !=
                                      _bottomNavigationBarRoutes[index].routeName) {
                                    AutoRouter.of(context).push(_bottomNavigationBarRoutes[index]);
                                    _currentIndex = index;
                                  }
                                },
                                items: [
                                  CustomBottomNavigationBarItem(
                                      svgIconPath: 'resources/images/svg/bottom_bar/home_icon.svg',
                                      svgActiveIconPath: 'resources/images/svg/bottom_bar/home_icon_active.svg',
                                      label: S.of(context).main),
                                  CustomBottomNavigationBarItem(
                                      svgIconPath: 'resources/images/svg/bottom_bar/history_icon.svg',
                                      svgActiveIconPath: 'resources/images/svg/bottom_bar/history_icon_active.svg',
                                      label: S.of(context).history)
                                ]),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }),
        ],
      ),
    );
  }

  void _scheduleBottomNavigationBarHeightUpdate() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var newBottomNavigationBarHeight =
          (_bottomNavigationBarKey.currentContext?.findRenderObject() as RenderBox?)?.size.height;
      if (newBottomNavigationBarHeight != _bottomNavigationBarHeight) {
        _bottomNavigationBarHeight = newBottomNavigationBarHeight;
      }
    });
  }
}
