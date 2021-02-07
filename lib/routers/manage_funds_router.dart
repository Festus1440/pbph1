import 'package:nuvigator/nuvigator.dart';
import 'package:flutter/material.dart';
import 'package:pb_ph1/presentation/screens/manage_funds/manage_cards.dart';
import 'package:pb_ph1/presentation/screens/manage_funds/manage_funds.dart';

part 'manage_funds_router.g.dart';

@nuRouter
class ManageFundsRouter extends NuRouter {


  @NuRoute()
  ScreenRoute manageFundsMain() => ScreenRoute(
    builder: (_) => ManageFunds()
  );

  @NuRoute(pushMethods: [PushMethodType.popAndPush])
  ScreenRoute manageCards() => ScreenRoute(
    builder: (_) => ManageCards()
  );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;
}