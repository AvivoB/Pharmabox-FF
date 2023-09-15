import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pharmabox/notifications/firebase_notifications_service.dart';
import 'package:pharmabox/profil/profil_provider.dart';
import 'package:pharmabox/profil_pharmacie/profil_pharmacie_provider.dart';
import 'package:pharmabox/profil_pharmacie/profil_pharmacie_widget.dart';
import 'package:pharmabox/profil_view_pharmacie/profil_view_pharmacie.dart';
import 'package:pharmabox/register_step/register_provider.dart';
import 'package:pharmabox/register_pharmacy/register_pharmacie_provider.dart';
import 'package:provider/provider.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'constant.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await FlutterFlowTheme.initialize();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("ce23a4c1-57e3-4379-913d-388977c0e0da");
  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
  OneSignal.login(await getCurrentUserId());
  // OneSignal.User.pushSubscription.addObserver((state) {
  //     print(state.current.jsonRepresentation());
  //   });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier();
    _router = createRouter(_appStateNotifier);
    userStream = pharmaboxFirebaseUserStream()..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(seconds: 1),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderUserRegister()),
        ChangeNotifierProvider(create: (_) => ProviderPharmacieRegister()),
        ChangeNotifierProvider(create: (_) => ProviderProfilUser()),
        ChangeNotifierProvider(create: (_) => ProviderPharmacieUser()),
      ],
      child: MaterialApp.router(
        title: 'Pharmabox',
        localizationsDelegates: [
          FFLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: _locale,
        supportedLocales: const [Locale('fr', 'FR')],
        theme: ThemeData(brightness: Brightness.light),
        debugShowCheckedModeBanner: false,
        // darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: _themeMode,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Explorer';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Explorer': ExplorerWidget(),
      'PharmaJob': PharmaJobWidget(),
      'Reseau': ReseauWidget(),
      'Profil': ProfilWidget(),
      'Pharmacie': ProfilPharmacie(),
      'UserView': ProfilViewWidget(),
      'PharmacieView': PharmacieProfilView(),
    };

    OneSignal.Notifications.addClickListener((event) {
      String fromId = event.notification.additionalData!['fromId'].toString() ?? '';
      print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: ${fromId}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiscussionUserWidget(toUser: fromId),
        ),
      );
    });

    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);
    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF7CEDAC),
        unselectedItemColor: greyColor,
        borderRadius: 8.0,
        itemBorderRadius: 8.0,
        margin: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
        width: double.infinity,
        elevation: 0.0,
        items: [
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentIndex == 0
                    ? ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)], // changez les couleurs comme vous le souhaitez
                          stops: [0.0, 1.0],
                        ).createShader(bounds),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      )
                    : Icon(
                        Icons.search,
                        color: greyColor,
                        size: 24.0,
                      ),
                Text(
                  'Explorer',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: currentIndex == 0 ? FontWeight.w600 : FontWeight.w400,
                    color: greyColor,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentIndex == 1
                    ? ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)], // changez les couleurs comme vous le souhaitez
                          stops: [0.0, 1.0],
                        ).createShader(bounds),
                        child: Icon(
                          Icons.campaign_outlined,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      )
                    : Icon(
                        Icons.campaign_outlined,
                        color: greyColor,
                        size: 24.0,
                      ),
                Text(
                  'PharmaJob',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: currentIndex == 1 ? FontWeight.w600 : FontWeight.w400,
                    color: greyColor,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentIndex == 2
                    ? ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)], // changez les couleurs comme vous le souhaitez
                          stops: [0.0, 1.0],
                        ).createShader(bounds),
                        child: Icon(
                          Icons.people_alt_outlined,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      )
                    : Icon(
                        Icons.people_alt_outlined,
                        color: greyColor,
                        size: 24.0,
                      ),
                Text(
                  'Réseau',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: currentIndex == 2 ? FontWeight.w600 : FontWeight.w400,
                    color: greyColor,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentIndex == 3 || currentIndex == -1
                    ? ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)], // changez les couleurs comme vous le souhaitez
                          stops: [0.0, 1.0],
                        ).createShader(bounds),
                        child: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      )
                    : Icon(
                        Icons.account_circle_outlined,
                        color: greyColor,
                        size: 24.0,
                      ),
                Text(
                  'Profil',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: currentIndex == 3 || currentIndex == -1 ? FontWeight.w600 : FontWeight.w400,
                    color: greyColor,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
