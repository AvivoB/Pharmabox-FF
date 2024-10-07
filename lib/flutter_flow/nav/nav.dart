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
        name: 'Annuaire',
        path: '/annuaire',
        builder: (context, state) => NavBarPage(initialPage: 'Annuaire'),
      ),
      GoRoute(
        name: 'Explorer',
        path: '/explorer',
        builder: (context, state) => NavBarPage(initialPage: 'Explorer'),
      ),
      GoRoute(
        name: 'RegisterPharmacy',
        path: '/registerPharmacy',
        builder: (context, state) => RegisterPharmacyWidget(titulaire: state.uri.queryParameters['titulaire'], countryCode: state.uri.queryParameters['countryCode']),
      ),
      GoRoute(name: 'PharmaJob', path: '/pharmaJob', builder: (context, state) => NavBarPage(initialPage: 'PharmaJob')),
      GoRoute(
          name: 'PharmaBlablaEditPost',
          path: '/PharmaBlablaEditPost',
          builder: (context, state) => NavBarPage(
              initialPage: 'PharmaBlabla',
              page: PharmaBlablaEditPost(
                theme: state.uri.queryParameters['theme'],
                postId: state.uri.queryParameters['postId'],
                content: state.uri.queryParameters['content'],
                network: state.uri.queryParameters['network'],
                poste: state.uri.queryParameters['poste'],
              ))),
      GoRoute(name: 'PharmaBlabla', path: '/pharmaBlabla', builder: (context, params) => NavBarPage(initialPage: 'PharmaBlabla', page: PharmaBlabla())),
      GoRoute(
          name: 'PharmaBlablaSinglePost',
          path: '/pharmaBlablaSinglePost',
          builder: (context, state) => NavBarPage(
              initialPage: 'PharmaBlabla',
              page: PharmaBlablaSinglePost(
                postId: state.uri.queryParameters['postId'],
              ))),
      GoRoute(
        name: 'Reseau',
        path: '/reseau',
        builder: (context, state) => NavBarPage(initialPage: 'Reseau', statePage: state.uri.queryParameters['typeIndex']),
      ),
      GoRoute(
          name: 'ReseauImportFromPhone',
          path: '/reseauImportFromPhone',
          builder: (context, state) => NavBarPage(initialPage: 'Reseau', page: ReseauImportFromPhone(type: state.uri.queryParameters['type']))),
      GoRoute(
        name: 'Profil',
        path: '/profil',
        builder: (context, state) => /* state.pathParameters.isEmpty */
            NavBarPage(initialPage: 'Accueil', page: ProfilWidget( tyeRedirect: state.uri.queryParameters['tyeRedirect']))
            // : ProfilWidget(
            //     tyeRedirect: state.uri.queryParameters['tyeRedirect'],
            //   ),
      ),
      GoRoute(name: 'PharmacieProfil', path: '/pharmacieProfil', builder: (context, params) => NavBarPage(initialPage: 'Accueil', page: ProfilPharmacie())),
      GoRoute(
        name: 'PharmacieProfilView',
        path: '/pharmacieProfilView',
        builder: (context, state) => NavBarPage(
          initialPage: 'Reseau',
          page: PharmacieProfilView(pharmacieId: state.uri.queryParameters['pharmacieId']),
        ),
      ),
      GoRoute(
        name: 'ProfilView',
        path: '/profilView',
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
  
}

extension GoRouterExtensions on GoRouter {
  bool shouldRedirect(bool ignoreRedirect) => !ignoreRedirect && AppStateNotifier().hasRedirect();
  void clearRedirectLocation() => AppStateNotifier().clearRedirectLocation();
}


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
