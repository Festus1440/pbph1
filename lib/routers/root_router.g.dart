// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class RootRoutes {
  static const manageFundsRoute = 'root/manageFundsRoute';
}

extension RootRouterNavigation on RootRouter {
  Future<Object> toManageFundsRoute() {
    return nuvigator.pushNamed<Object>(
      RootRoutes.manageFundsRoute,
    );
  }

  Future<Object> pushReplacementToManageFundsRoute<TO extends Object>(
      {TO result}) {
    return nuvigator.pushReplacementNamed<Object, TO>(
      RootRoutes.manageFundsRoute,
      result: result,
    );
  }

  Future<Object> pushAndRemoveUntilToManageFundsRoute<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<Object>(
      RootRoutes.manageFundsRoute,
      predicate,
    );
  }

  Future<Object> popAndPushToManageFundsRoute<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<Object, TO>(
      RootRoutes.manageFundsRoute,
      result: result,
    );
  }
}

extension RootRouterScreensAndRouters on RootRouter {
  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(RootRoutes.manageFundsRoute): (RouteSettings settings) {
        return manageFundsRoute();
      },
    };
  }
}
