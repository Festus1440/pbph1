// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manage_funds_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class ManageFundsRoutes {
  static const manageFundsMain = 'manageFunds/manageFundsMain';

  static const manageCards = 'manageFunds/manageCards';
}

extension ManageFundsRouterNavigation on ManageFundsRouter {
  Future<Object> toManageFundsMain() {
    return nuvigator.pushNamed<Object>(
      ManageFundsRoutes.manageFundsMain,
    );
  }

  Future<Object> pushReplacementToManageFundsMain<TO extends Object>(
      {TO result}) {
    return nuvigator.pushReplacementNamed<Object, TO>(
      ManageFundsRoutes.manageFundsMain,
      result: result,
    );
  }

  Future<Object> pushAndRemoveUntilToManageFundsMain<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<Object>(
      ManageFundsRoutes.manageFundsMain,
      predicate,
    );
  }

  Future<Object> popAndPushToManageFundsMain<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<Object, TO>(
      ManageFundsRoutes.manageFundsMain,
      result: result,
    );
  }

  Future<Object> popAndPushToManageCards<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<Object, TO>(
      ManageFundsRoutes.manageCards,
      result: result,
    );
  }

  Future<Object> toManageCards() {
    return nuvigator.pushNamed<Object>(
      ManageFundsRoutes.manageCards,
    );
  }
}

extension ManageFundsRouterScreensAndRouters on ManageFundsRouter {
  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(ManageFundsRoutes.manageFundsMain): (RouteSettings settings) {
        return manageFundsMain();
      },
      RouteDef(ManageFundsRoutes.manageCards): (RouteSettings settings) {
        return manageCards();
      },
    };
  }
}
