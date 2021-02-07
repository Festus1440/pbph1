import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:pb_ph1/routers/manage_funds_router.dart';

part 'root_router.g.dart';

@nuRouter
class RootRouter extends NuRouter {

  // @nuRouter
  // final manageFundsRouter = ManageFundsRouter();

  @NuRoute()
  ScreenRoute manageFundsRoute() => ScreenRoute(
      builder: Nuvigator(
        router: ManageFundsRouter(),
        initialRoute: ManageFundsRoutes.manageFundsMain,
        screenType: cupertinoScreenType,
        shouldPopRoot: true,
      )
  );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;
}