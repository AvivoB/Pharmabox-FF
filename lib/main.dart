import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pharmabox/auth/AuthProvider.dart';
import 'package:pharmabox/backend/firebase_messaging/firebase_messaging.dart';
import 'package:pharmabox/notifications/firebase_notifications_service.dart';
import 'package:pharmabox/profil/profil_provider.dart';
import 'package:pharmabox/profil_pharmacie/profil_pharmacie_provider.dart';
import 'package:pharmabox/profil_pharmacie/profil_pharmacie_widget.dart';
import 'package:pharmabox/profil_view_pharmacie/profil_view_pharmacie.dart';
import 'package:pharmabox/register_step/register_provider.dart';
import 'package:pharmabox/register_pharmacy/register_pharmacie_provider.dart';
import 'package:pharmabox/reseau/reseau_import_from_phone.dart';
import 'package:provider/provider.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';
import 'package:upgrader/upgrader.dart';
import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'flutter_flow/nav/AppStateNotifier.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'constant.dart';
import 'package:uni_links/uni_links.dart';
import 'pharmablabla/pharmablabla_widget.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  final token = await FirebaseMessaging.instance.getToken();
  print('FCM Token : ${token}');
  await setupFlutterNotifications();
  PushNotification.displayLocalNotification(message.notification?.title ?? 'Titre', message.notification?.body ?? 'Nouveau message');
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await FlutterFlowTheme.initialize();
  PushNotification.init();
  FirebaseMessaging.onMessage.listen((event) {
    // do something
  });

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  firebaseMessaging.onTokenRefresh.listen((event) {
    if (currentUser != null) {
      print('token $event');
      FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
        'fcmToken': event,
      });
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('clicked notif : $event');
  });
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

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
  ThemeMode _themeMode = ThemeMode.light;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Stream<BaseAuthUser> userStream;

  // late AppStateNotifier _appStateNotifier;

  final authUserSub = authenticatedUserStream.listen((_) {});

  /* DEEP LINKS */
  StreamSubscription? _sub;
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;

  @override
  void initState() {
    super.initState();
    AppStateNotifier _appStateNotifier = AppStateNotifier();
    // _router = createRouter(_appStateNotifier);
    userStream = pharmaboxFirebaseUserStream()..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    // Future.delayed(
    //   Duration(seconds: 1),
    //   () => _appStateNotifier.stopShowingSplashImage(),
    // );
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    authUserSub.cancel();
    _sub?.cancel();
    super.dispose();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        print('got uri: ' + uri!.path);
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
        theme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        // darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: _themeMode,
        // routeInformationParser: _router.routeInformationParser,
        // routerDelegate: _router.routerDelegate,
        routerConfig: routerApp
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
      'PharmaBlabla': PharmaBlabla(currentPage: _currentPageName),
      'Reseau': ReseauWidget(),
      'Profil': ProfilWidget(),
      'Pharmacie': ProfilPharmacie(),
    };

    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);
    

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: Colors.white,
        // selectedItemColor: Color(0xFF7CEDAC),
        unselectedItemColor: Colors.transparent,
        // borderRadius: 8.0,
        // itemBorderRadius: 8.0,
        // margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        // padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
        // width: double.infinity,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
        selectedFontSize: 0,
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Column(
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
                Text('Explorer', overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 10, fontWeight: currentIndex == 0 ? FontWeight.w500 : FontWeight.w400)),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Column(
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
                Text('Jobs', overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 10, fontWeight: currentIndex == 1 ? FontWeight.w500 : FontWeight.w400)),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Stack(
              alignment: Alignment.center,
              children: [
                 Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            Icons.forum_outlined,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        )
                      : Icon(
                          Icons.forum_outlined,
                          color: greyColor,
                          size: 24.0,
                        ),
                  Text(
                    'Blabla',
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Poppins',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 10,
                          fontWeight: currentIndex == 2 ? FontWeight.w500 : FontWeight.w400,
                        ),
                  )
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('pharmablabla').where('network', isEqualTo: 'Tout Pharmabox').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // Display the error message
                      print('${snapshot.error}');
                    }

                    // Filter documents where 'users_viewed' does not contain currentUserId
                    var filteredDocs = snapshot.data?.docs.where((doc) => !(doc['users_viewed']?.contains(currentUserUid) ?? false));

                    final int unreadNotificationsCount = filteredDocs?.length ?? 0;
                    if (unreadNotificationsCount > 0) {
                      return Positioned(
                        top: -3.0, // Adjust as needed
                        right: 0.0, // Adjust as needed
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(3.0, 3.0, 3.0, 3.0),
                            child: Text(
                              unreadNotificationsCount.toString(),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    fontSize: 10.0,
                                  ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
             
            ]),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Stack(
              alignment: Alignment.center,
              children: [
                 Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  currentIndex == 3
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
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Poppins',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 10,
                          fontWeight: currentIndex == 2 ? FontWeight.w500 : FontWeight.w400,
                        ),
                  )
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('demandes_network').where('for', isEqualTo: currentUserUid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // Display the error message
                      print('${snapshot.error}');
                    }

                    // Filter documents where 'users_viewed' does not contain currentUserId
                    // var filteredDocs = snapshot.data?.docs.where((doc) => !(doc['for']?.contains(currentUserUid) ?? false));

                    final int unreadNotificationsCount = snapshot.data?.docs.length ?? 0;
                    if (unreadNotificationsCount > 0) {
                      return Positioned(
                        top: -3.0, // Adjust as needed
                        right: 0.0, // Adjust as needed
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(3.0, 3.0, 3.0, 3.0),
                            child: Text(
                              unreadNotificationsCount.toString(),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    fontSize: 10.0,
                                  ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
             
            ]),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentIndex == 4 || currentIndex == -1
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
                Text('Profil', overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 10, fontWeight: currentIndex == 4 ? FontWeight.w500 : FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
