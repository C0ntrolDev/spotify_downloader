import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify_downloader/core/app/colors/colors.dart';
import 'package:spotify_downloader/core/app/router/router.dart';
import 'package:spotify_downloader/core/di/injector.dart';
import 'package:spotify_downloader/core/permissions/permissions_manager.dart';
import 'package:spotify_downloader/core/permissions/requiring_permission_services_initializer.dart';
import 'package:spotify_downloader/features/presentation/main/tools/bottom_navigation_bar_observer.dart';
import 'package:spotify_downloader/features/presentation/main/widgets/custom_navigation_bar/custom_navigation_bar_acessor.dart';
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
      body: StreamBuilder(
          initialData: 0,
          stream: _currentIndexStreamController.stream,
          builder: (context, value) {
            return CustomNavigationBar(
                expandBody: true,
                verticalContentPadding: const EdgeInsets.only(left: 20, right: 20, top: 17, bottom: 7),
                horizontalContentPadding: EdgeInsets.zero,
                verticalBackgroundDecorations: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(230, 0, 0, 0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                horizontalBackgroundDecorations: const BoxDecoration(),
                verticalLabelFontSize: 10,
                horizontalLabelFontSize: 12,
                iconSize: const Size(25, 25),
                selectedItemColor: onBackgroundPrimaryColor,
                unselectedItemColor: onBackgroundSecondaryColor,
                selectingItemColor: onBackgroundThirdRateColor,
                selectingSize: 0.9,
                animationDuration: const Duration(milliseconds: 50),
                currentIndex: value.data!,
                onTap: (index) {
                  if (AutoRouter.of(context).topRoute.name != _bottomNavigationBarRoutes[index].routeName) {
                    AutoRouter.of(context).push(_bottomNavigationBarRoutes[index]);
                    _currentIndex = index;
                  }
                },
                items: [
                  CustomNavigationBarItem(
                      svgIconPath: 'resources/images/svg/bottom_bar/home_icon.svg',
                      svgActiveIconPath: 'resources/images/svg/bottom_bar/home_icon_active.svg',
                      label: S.of(context).main),
                  CustomNavigationBarItem(
                      svgIconPath: 'resources/images/svg/bottom_bar/history_icon.svg',
                      svgActiveIconPath: 'resources/images/svg/bottom_bar/history_icon_active.svg',
                      label: S.of(context).history)
                ],
                child: AutoRouter(
                  navigatorObservers: () => [_routeObserver],
                ));
          }),
    );
  }
}

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar(
      {super.key,
      required this.child,
      required this.items,
      required this.onTap,
      required this.currentIndex,
      required this.expandBody,
      required this.verticalContentPadding,
      required this.horizontalContentPadding,
      required this.verticalBackgroundDecorations,
      required this.horizontalBackgroundDecorations,
      required this.verticalLabelFontSize,
      required this.horizontalLabelFontSize,
      required this.iconSize,
      required this.selectingSize,
      required this.selectedItemColor,
      required this.unselectedItemColor,
      required this.selectingItemColor,
      required this.animationDuration});

  final Widget child;

  final List<CustomNavigationBarItem> items;
  final void Function(int index) onTap;
  final int currentIndex;

  final bool expandBody;
  final EdgeInsetsGeometry verticalContentPadding;
  final EdgeInsetsGeometry horizontalContentPadding;
  final BoxDecoration verticalBackgroundDecorations;
  final BoxDecoration horizontalBackgroundDecorations;
  final double verticalLabelFontSize;
  final double horizontalLabelFontSize;
  final Size iconSize;
  final double selectingSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectingItemColor;
  final Duration animationDuration;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  final GlobalKey _bottomNavigationBarKey = GlobalKey();

  double? _expandedHeightField;
  double? get _expandedHeight => _expandedHeightField;
  set _expandedHeight(double? newHeight) {
    _expandedHeightField = newHeight;
    _expandedHeightStreamController.add(newHeight);
  }

  final StreamController<double?> _expandedHeightStreamController = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.portrait) {
          _scheduleBottomNavigationBarHeightUpdate();
          return _wrapBottomNavigationBar(
              isExpandedBody: widget.expandBody,
              child: StreamBuilder<double?>(
                  stream: _expandedHeightStreamController.stream,
                  builder: (context, value) {
                    return CustomNavigationBarAcessor(expandedHeight: value.data, child: widget.child);
                  }),
              bottomNavigationBar: CustomBottomNavigationBar(
                key: _bottomNavigationBarKey,
                items: widget.items,
                iconSize: widget.iconSize,
                labelFontSize: widget.verticalLabelFontSize,
                selectedItemColor: widget.selectedItemColor,
                unselectedItemColor: widget.unselectedItemColor,
                selectingItemColor: widget.selectingItemColor,
                onTap: widget.onTap,
                currentIndex: widget.currentIndex,
                selectingSize: widget.selectingSize,
                animationDuration: widget.animationDuration,
                contentPadding: widget.verticalContentPadding,
                backgroundDecorations: widget.verticalBackgroundDecorations,
              ));
        } else {
          _expandedHeight = 0;
          return Container();
        }
      },
    );
  }

  Widget _wrapBottomNavigationBar(
      {required bool isExpandedBody, required Widget child, required Widget bottomNavigationBar}) {
    if (isExpandedBody) {
      return Stack(
        children: [child, Align(alignment: Alignment.bottomCenter, child: bottomNavigationBar)],
      );
    } else {
      return Column(
        children: [Expanded(child: child), bottomNavigationBar],
      );
    }
  }

  void _scheduleBottomNavigationBarHeightUpdate() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var newExpandedHeight = (_bottomNavigationBarKey.currentContext?.findRenderObject() as RenderBox?)?.size.height;
      if (newExpandedHeight != _expandedHeight) {
        _expandedHeight = newExpandedHeight;
      }
    });
  }
}

class CustomNavigationBarItem {
  CustomNavigationBarItem({required this.svgIconPath, required this.svgActiveIconPath, required this.label});

  final String svgIconPath;
  final String svgActiveIconPath;
  final String label;
}

class CustomBottomNavigationBar extends StatelessWidget {
  final List<CustomNavigationBarItem> items;
  final void Function(int index) onTap;
  final int currentIndex;

  final EdgeInsetsGeometry contentPadding;
  final BoxDecoration backgroundDecorations;
  final Size iconSize;
  final double labelFontSize;
  final double selectingSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectingItemColor;
  final Duration animationDuration;

  const CustomBottomNavigationBar(
      {super.key,
      required this.items,
      required this.iconSize,
      required this.labelFontSize,
      required this.selectedItemColor,
      required this.unselectedItemColor,
      required this.selectingItemColor,
      required this.onTap,
      required this.currentIndex,
      required this.selectingSize,
      required this.animationDuration,
      required this.contentPadding,
      required this.backgroundDecorations});

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          padding: contentPadding,
          alignment: Alignment.bottomCenter,
          decoration: backgroundDecorations,
          child: Theme(
              data: ThemeData(
                splashFactory: NoSplash.splashFactory,
                highlightColor: const Color.fromARGB(0, 0, 0, 0),
              ),
              child: Row(
                children: items.map((item) {
                  final isSelected = i == currentIndex;
                  final itemIndex = i;
                  i++;

                  return Expanded(
                      child: CustomBottomNavigationBarItemTile(
                    item: item,
                    iconSize: iconSize,
                    labelFontSize: labelFontSize,
                    selectedItemColor: selectedItemColor,
                    selectingItemColor: selectingItemColor,
                    selectingSize: selectingSize,
                    unselectedItemColor: unselectedItemColor,
                    isSelected: isSelected,
                    onTap: () => onTap(itemIndex),
                    animationDuration: animationDuration,
                  ));
                }).toList(),
              )))
    ]);
  }
}

abstract class CustomNavigationBarItemTile extends StatefulWidget {
  final CustomNavigationBarItem item;
  final Size iconSize;
  final double labelFontSize;
  final double selectingSize;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectingItemColor;
  final Duration animationDuration;
  final void Function() onTap;
  final bool isSelected;

  const CustomNavigationBarItemTile(
      {super.key,
      required this.iconSize,
      required this.labelFontSize,
      required this.selectingSize,
      required this.selectedItemColor,
      required this.unselectedItemColor,
      required this.selectingItemColor,
      required this.onTap,
      required this.isSelected,
      required this.item,
      required this.animationDuration});
}

abstract class CustomNavigationBarItemTileState<T extends CustomNavigationBarItemTile> extends State<T>
    with TickerProviderStateMixin {
  late final AnimationController _colorAnimationController;
  late final AnimationController _sizeAnimationController;

  Animation<double>? sizeAnimation;
  Animation<Color?>? colorAnimation;

  bool isTapping = false;

  Color get initialColor => widget.isSelected ? widget.selectedItemColor : widget.unselectedItemColor;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _sizeAnimationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _updateAnimations();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    if (oldWidget.isSelected != widget.isSelected) {
      _updateAnimations();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateAnimations() {
    final beginColor = colorAnimation?.value ?? initialColor;
    final endColor = isTapping
        ? widget.selectingItemColor
        : widget.isSelected
            ? widget.selectedItemColor
            : widget.unselectedItemColor;

    final double beginSize = sizeAnimation?.value ?? 1;
    final double endSize = isTapping ? widget.selectingSize : 1;

    if (beginColor != endColor || colorAnimation == null) {
      _colorAnimationController.reset();
      colorAnimation = ColorTween(begin: beginColor, end: endColor).animate(_colorAnimationController);
      _colorAnimationController.forward();
    }

    if (beginSize != endSize || sizeAnimation == null) {
      _sizeAnimationController.reset();
      sizeAnimation = Tween<double>(begin: beginSize, end: endSize).animate(_sizeAnimationController);
      _sizeAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (details) {
          isTapping = true;
          _updateAnimations();
        },
        onTapUp: (details) {
          isTapping = false;
          widget.onTap();
          _updateAnimations();
        },
        onTapCancel: () {
          isTapping = false;
          _updateAnimations();
        },
        child: AnimatedBuilder(
            animation: sizeAnimation!,
            builder: (context, _) {
              return AnimatedBuilder(
                  animation: colorAnimation!,
                  builder: (context, _) {
                    if (sizeAnimation == null || colorAnimation == null || colorAnimation!.value == null) {
                      return Container();
                    }
                    return _buildWithAnimations(sizeAnimation!.value, colorAnimation!.value!);
                  });
            }));
  }

  Widget _buildWithAnimations(double animatedSize, Color animatedColor);
}

class CustomBottomNavigationBarItemTile extends CustomNavigationBarItemTile {
  const CustomBottomNavigationBarItemTile(
      {super.key,
      required super.iconSize,
      required super.labelFontSize,
      required super.selectingSize,
      required super.selectedItemColor,
      required super.unselectedItemColor,
      required super.selectingItemColor,
      required super.onTap,
      required super.isSelected,
      required super.item,
      required super.animationDuration});

  @override
  State<CustomBottomNavigationBarItemTile> createState() => _CustomBottomNavigationBarItemTileState();
}

class _CustomBottomNavigationBarItemTileState
    extends CustomNavigationBarItemTileState<CustomBottomNavigationBarItemTile> {
  @override
  Widget _buildWithAnimations(double animatedSize, Color animatedColor) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              widget.isSelected ? widget.item.svgActiveIconPath : widget.item.svgIconPath,
              width: widget.iconSize.width * sizeAnimation!.value,
              height: widget.iconSize.height * sizeAnimation!.value,
              colorFilter: ColorFilter.mode(colorAnimation!.value!, BlendMode.srcIn),
            ),
            Text(widget.item.label,
                style: TextStyle(color: colorAnimation!.value, fontSize: widget.labelFontSize * sizeAnimation!.value))
          ],
        ),
      ),
    );
  }
}
