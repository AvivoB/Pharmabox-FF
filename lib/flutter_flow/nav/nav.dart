import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmabox/auth/AuthProvider.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/desactivated_account/desactivated_account.dart';
import 'package:pharmabox/helper_center/helper_center_widget.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_edit_post_widget.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_single_post_widget.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_widget.dart';
import 'package:pharmabox/profil/profil_suppression.dart';
import 'package:pharmabox/profil_view_pharmacie/profil_view_pharmacie.dart';
import 'package:pharmabox/register_validation_account/register_validation_account.dart';
import 'package:pharmabox/reseau/reseau_import_from_phone.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import '../../profil_pharmacie/profil_pharmacie_widget.dart';
import '../flutter_flow_theme.dart';
import '../../backend/backend.dart';

import '../../auth/base_auth_user_provider.dart';

import '../../index.dart';
import '../../main.dart';
import '../lat_lng.dart';
import '../place.dart';
import 'AppStateNotifier.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

final AppStateNotifier appStateNotifier = AppStateNotifier();



Widget decideFirstPage(context) {
  final authProvider = Provider.of<AuthProvider>(context);

  if(authProvider.isLoadingAuth){
    return ProgressIndicatorPharmabox();
  }

  if(authProvider.user == null){
    return RegisterWidget();
  }

  return NavBarPage();
}

final GoRouter routerApp = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    // refreshListenable: appStateNotifier,
    // errorBuilder: (context, _) => decideInitialPage(appStateNotifier),
    // redirect: (BuildContext context, GoRouterState state) {
    //   final authProvider = Provider.of<AuthProvider>(context, listen: false);

    //   print('state authProvider.user : ' + authProvider.user.toString());
    //   print('state PAth : ' + state.path.toString());

    //   // Si l'utilisateur est déconnecté
    //   // if (authProvider.user == null && state.path == null) {
    //   //     return '/register';
    //   // }
    //   if (authProvider.user == null && state.path == '/register') {
    //       return '/register';
    //   }
    //   if (authProvider.user == null && state.path == '/login') {
    //       return '/login';
    //   }
    //   if (authProvider.user == null && state.path == '/passwordReset') {
    //       return '/passwordReset';
    //   }

    // },
    routes: [
      GoRoute(
        name: '_initialize',
        path: '/',
        builder: (context, state) => UpgradeAlert(
          child: decideFirstPage(context),
        ),
      ),
      GoRoute(
        name: 'Register',
        path: '/register',
        builder: (context, state) => RegisterWidget(),
      ),
      GoRoute(
        name: 'Login',
        path: '/login',
        builder: (context, state) => LoginWidget(),
      ),
      GoRoute(
        name: 'PasswordReset',
        path: '/passwordReset',
        builder: (context, state) => PasswordResetWidget(),
      ),
      GoRoute(
        name: 'RegisterStep',
        path: '/registerStep',
        builder: (context, state) => RegisterStepWidget(),
      ),
      GoRoute(
        name: 'ValidateAccount',
        path: '/validateAccount',
        builder: (context, state) => ValidateAccount(),
      ),
      GoRoute(
        name: 'Explorer',
        path: '/explorer',
        builder: (context, state) => /* params.isEmpty ?  */ NavBarPage(initialPage: 'Explorer') /* : ExplorerWidget() */,
      ),
      GoRoute(
        name: 'RegisterPharmacy',
        path: '/registerPharmacy',
        // builder: (context, state) => RegisterPharmacyWidget(/* titulaire: params.getParam('titulaire', ParamType.String) */ titulaire: state.pathParameters['titulaire'], countryCode: params.getParam('countryCode', ParamType.String)),
        builder: (context, state) => RegisterPharmacyWidget(titulaire: state.uri.queryParameters['titulaire'], countryCode: state.uri.queryParameters['countryCode']),
      ),
      GoRoute(name: 'PharmaJob', path: '/pharmaJob', builder: (context, state) => NavBarPage(initialPage: 'PharmaJob')),
      GoRoute(
          name: 'PharmaBlablaEditPost',
          path: '/PharmaBlablaEditPost',
          // builder: (context, state) => NavBarPage(initialPage: 'PharmaBlabla', page: PharmaBlablaEditPost(
          // data: params.getParam('data', ParamType.String),
          builder: (context, state) => NavBarPage(
              initialPage: 'PharmaBlabla',
              page: PharmaBlablaEditPost(
                lgo: state.uri.queryParameters['LGO'],
                postId: state.uri.queryParameters['postId'],
                content: state.uri.queryParameters['content'],
                network: state.uri.queryParameters['network'],
                poste: state.uri.queryParameters['poste'],
              ))),
      GoRoute(name: 'PharmaBlabla', path: '/pharmaBlabla', builder: (context, params) => NavBarPage(initialPage: 'PharmaBlabla', page: PharmaBlabla())),
      GoRoute(
          name: 'PharmaBlablaSinglePost',
          path: '/pharmaBlablaSinglePost',
          // builder: (context, params) => NavBarPage(
          //     initialPage: 'PharmaBlabla',
          //     page: PharmaBlablaSinglePost(
          //       postId: params.getParam('postId', ParamType.String),
          //     ))),
          builder: (context, state) => NavBarPage(
              initialPage: 'PharmaBlabla',
              page: PharmaBlablaSinglePost(
                postId: state.uri.queryParameters['postId'],
              ))),
      GoRoute(
        name: 'Reseau',
        path: '/reseau',
        // builder: (context, params) => params.isEmpty ? NavBarPage(initialPage: 'Reseau') : ReseauWidget(),
        builder: (context, params) => NavBarPage(initialPage: 'Reseau'),
      ),
      GoRoute(
          name: 'ReseauImportFromPhone',
          path: '/reseauImportFromPhone',
          // builder: (context, params) => NavBarPage(initialPage: 'Reseau', page: ReseauImportFromPhone(type: params.getParam('type', ParamType.String)))),
          builder: (context, state) => NavBarPage(initialPage: 'Reseau', page: ReseauImportFromPhone(type: state.uri.queryParameters['type']))),
      GoRoute(
        name: 'Profil',
        path: '/profil',
        // builder: (context, params) => params.isEmpty
        //     ? NavBarPage(initialPage: 'Profil')
        //     : ProfilWidget(
        //         tyeRedirect: params.getParam('tyeRedirect', ParamType.String),
        //       ),
        builder: (context, state) => state.pathParameters.isEmpty
            ? NavBarPage(initialPage: 'Profil')
            : ProfilWidget(
                tyeRedirect: state.uri.queryParameters['tyeRedirect'],
              ),
      ),
      GoRoute(name: 'PharmacieProfil', path: '/pharmacieProfil', builder: (context, params) => NavBarPage(initialPage: 'Profil', page: ProfilPharmacie())),
      GoRoute(
        name: 'PharmacieProfilView',
        path: '/pharmacieProfilView',
        // builder: (context, params) => NavBarPage(
        //   initialPage: 'Reseau',
        //   page: PharmacieProfilView(pharmacieId: params.getParam('pharmacieId', ParamType.String)),
        builder: (context, state) => NavBarPage(
          initialPage: 'Reseau',
          page: PharmacieProfilView(pharmacieId: state.uri.queryParameters['pharmacieId']),
        ),
      ),
      GoRoute(
        name: 'ProfilView',
        path: '/profilView',
        // builder: (context, params) => NavBarPage(
        //   initialPage: 'Reseau',
        //   page: ProfilViewWidget(
        //     userId: params.getParam('userId', ParamType.String),
        //   ),
        builder: (context, state) => NavBarPage(
          initialPage: 'Reseau',
          page: ProfilViewWidget(
            userId: state.uri.queryParameters['userId'],
          ),
        ),
      ),
      GoRoute(
        name: 'DiscussionUser',
        path: '/discussionUser',
        // builder: (context, params) => DiscussionUserWidget(
        //   toUser: params.getParam('chatUser', ParamType.Document),
        // ),
        builder: (context, state) => DiscussionUserWidget(
          toUser: state.uri.queryParameters['chatUser'].toString(),
        ),
      ),
      GoRoute(
        name: 'Disucssions',
        path: '/disucssions',
        builder: (context, params) => DisucssionsWidget(),
      ),
      GoRoute(
        name: 'DeleteAccount',
        path: '/deleteAccount',
        // builder: (context, params) => params.isEmpty ? NavBarPage(initialPage: 'DeleteAccount') : ProfilDeleteAccount(),
        builder: (context, params) => params.pathParameters.isEmpty ? NavBarPage(initialPage: 'DeleteAccount') : ProfilDeleteAccount(),
      ),
      GoRoute(
        name: 'HelperCenter',
        path: '/helperCenter',
        builder: (context, params) => HelpPage()
      )
    ] /* .map((r) => r.toRoute(appStateNotifier)).toList(), */
    // urlPathStrategy: UrlPathStrategy.path,
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  // void goNamedAuth(
  //   String name,
  //   bool mounted, {
  //   Map<String, String> params = const <String, String>{},
  //   Map<String, String> queryParams = const <String, String>{},
  //   Object? extra,
  //   bool ignoreRedirect = false,
  // }) =>
  //     !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
  //         ? null
  //         : goNamed(
  //             name,
  //             params: params,
  //             queryParameters: queryParams,
  //             extra: extra,
  //           );

  // void pushNamedAuth(
  //   String name,
  //   bool mounted, {
  //   Map<String, String> params = const <String, String>{},
  //   Map<String, String> queryParams = const <String, String>{},
  //   Object? extra,
  //   bool ignoreRedirect = false,
  // }) =>
  //     !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
  //         ? null
  //         : pushNamed(
  //             name,
  //             params: params,
  //             queryParameters: queryParams,
  //             extra: extra,
  //           );

  // void safePop() {
  //   // If there is only one route on the stack, navigate to the initial
  //   // page instead of popping.
  //   if (GoRouter.of(this).routerDelegate.matches.length <= 1) {
  //     go('/');
  //   } else {
  //     pop();
  //   }
  // }
}

extension GoRouterExtensions on GoRouter {
  // AppStateNotifier get appState => (routerDelegate as AppStateNotifier);
  // void prepareAuthEvent([bool ignoreRedirect = false]) => AppStateNotifier().hasRedirect() && !ignoreRedirect ? null : AppStateNotifier().updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) => !ignoreRedirect && AppStateNotifier().hasRedirect();
  void clearRedirectLocation() => AppStateNotifier().clearRedirectLocation();
  // void setRedirectLocationIfUnset(String location) => (routerDelegate as AppStateNotifier).updateNotifyOnAuthChange(false);
}

// extension _GoRouterStateExtensions on GoRouterState {
//   Map<String, dynamic> get extraMap => extra != null ? extra as Map<String, dynamic> : {};
//   Map<String, dynamic> get allParams => <String, dynamic>{}
//     ..addAll(params)
//     ..addAll(queryParams)
//     ..addAll(extraMap);
//   TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey) ? extraMap[kTransitionInfoKey] as TransitionInfo : TransitionInfo.appDefault();
// }

// class FFParameters {
//   FFParameters(this.state, [this.asyncParams = const {}]);

//   final GoRouterState state;
//   final Map<String, Future<dynamic> Function(String)> asyncParams;

//   Map<String, dynamic> futureParamValues = {};

//   // Parameters are empty if the params map is empty or if the only parameter
//   // present is the special extra parameter reserved for the transition info.
//   bool get isEmpty => state.allParams.isEmpty || (state.extraMap.length == 1 && state.extraMap.containsKey(kTransitionInfoKey));
//   bool isAsyncParam(MapEntry<String, dynamic> param) => asyncParams.containsKey(param.key) && param.value is String;
//   bool get hasFutures => state.allParams.entries.any(isAsyncParam);
//   Future<bool> completeFutures() => Future.wait(
//         state.allParams.entries.where(isAsyncParam).map(
//           (param) async {
//             final doc = await asyncParams[param.key]!(param.value).onError((_, __) => null);
//             if (doc != null) {
//               futureParamValues[param.key] = doc;
//               return true;
//             }
//             return false;
//           },
//         ),
//       ).onError((_, __) => [false]).then((v) => v.every((e) => e));

//   dynamic getParam<T>(
//     String paramName,
//     ParamType type, [
//     bool isList = false,
//     List<String>? collectionNamePath,
//   ]) {
//     print(paramName);
//     if (futureParamValues.containsKey(paramName)) {
//       return futureParamValues[paramName];
//     }
//     if (!state.allParams.containsKey(paramName)) {
//       return null;
//     }
//     final param = state.allParams[paramName];
//     // Got parameter from `extras`, so just directly return it.
//     if (param is! String) {
//       return param;
//     }
//     // Return serialized value.
//     return deserializeParam<T>(param, type, isList, collectionNamePath);
//   }
// }

// class FFRoute {
//   const FFRoute({
//     required this.name,
//     required this.path,
//     required this.builder,
//     this.requireAuth = false,
//     this.asyncParams = const {},
//     this.routes = const [],
//   });

//   final String name;
//   final String path;
//   final bool requireAuth;
//   final Map<String, Future<dynamic> Function(String)> asyncParams;
//   final Widget Function(BuildContext, FFParameters) builder;
//   final List<GoRoute> routes;

//   GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
//         name: name,
//         path: path,
//         // redirect: (_) => '/family/${Families.data[0].id}',
//         // redirect: (state) {
//         //   if (appStateNotifier.shouldRedirect) {
//         //     final redirectLocation = appStateNotifier.getRedirectLocation();
//         //     appStateNotifier.clearRedirectLocation();
//         //     return redirectLocation;
//         //   }

//         //   if (requireAuth && !appStateNotifier.loggedIn) {
//         //     appStateNotifier.setRedirectLocationIfUnset(state.location);
//         //     return '/register';
//         //   }
//         //   return null;
//         // },
//         pageBuilder: (context, state) {
//           final ffParams = FFParameters(state, asyncParams);
//           final page = ffParams.hasFutures
//               ? FutureBuilder(
//                   future: ffParams.completeFutures(),
//                   builder: (context, _) => builder(context, ffParams),
//                 )
//               : builder(context, ffParams);
//           final child = appStateNotifier.loading
//               ? Center(
//                   child: SizedBox(
//                     width: 50.0,
//                     height: 50.0,
//                     child: CircularProgressIndicator(
//                       color: FlutterFlowTheme.of(context).accent3,
//                     ),
//                   ),
//                 )
//               : page;

//           final transitionInfo = state.transitionInfo;
//           return transitionInfo.hasTransition
//               ? CustomTransitionPage(
//                   key: state.pageKey,
//                   child: child,
//                   transitionDuration: transitionInfo.duration,
//                   transitionsBuilder: PageTransition(
//                     type: transitionInfo.transitionType,
//                     duration: transitionInfo.duration,
//                     reverseDuration: transitionInfo.duration,
//                     alignment: transitionInfo.alignment,
//                     child: child,
//                   ).transitionsBuilder,
//                 )
//               : MaterialPage(key: state.pageKey, child: child);
//         },
//         routes: routes,
//       );
// }

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}
