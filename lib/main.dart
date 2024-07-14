import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:geolocator/geolocator.dart';

// kakao login
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

// screens
import 'package:app/screens/home/home.dart';
import 'package:app/screens/BookManage/book_manage.dart';
import 'package:app/screens/mypage/mypage.dart';

// global variables
import 'package:app/globals.dart';
import 'package:app/globals.dart' as globals;

// API
import 'package:app/data/api_wrapper.dart' as moca_api;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: 'assets/config/.env');

  globals.kakaoAppKey = dotenv.get("kakao_app_key");
  KakaoSdk.init(nativeAppKey: globals.kakaoAppKey);

  globals.kakaoRestApiKey = dotenv.get("kakao_rest_api_key");

  globals.localData = await SharedPreferences.getInstance();
  Map userData = await preferences.getLocal("moca_user");

  if (userData.isNotEmpty) {
    MocaUser.fromMap(userData);
    globals.isLoggedIn = true;
    MocaUser.updateUser();
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('permissions are denied');
    }
  }

  Position position = await Geolocator.getCurrentPosition();
  MocaUser.latitude = position.latitude.toString();
  MocaUser.longitude = position.longitude.toString();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MocaThemeData.lightThemeData,
      home: const SafeArea(
        child: Main(),
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  void _setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();
  }

  late final List<Widget> _widgetOptions = <Widget>[
    BookManagePage(
      setParentIndex: _setIndex,
    ),
    const HomeScreen(),
    const MyPageScreen()
  ];

  @override
  Widget build(BuildContext context) {
    globals.ScreenSize.height = MediaQuery.of(context).size.height;
    globals.ScreenSize.width = MediaQuery.of(context).size.width;
    globals.ScreenSize.bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: _selectedIndex == 1 ? const Size.fromHeight(80.0) : const Size.fromHeight(0.0),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: AppBarTitle(selectedIndex: _selectedIndex),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10.0,
              spreadRadius: -2.0,
              offset: Offset(0.0, 0.0),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
              if (!globals.isLoggedIn && _selectedIndex == 2) {
                const MyPageScreen().showLoginPopup(context);
                _selectedIndex = 1;
                globals.isLoggedIn = globals.isLoggedIn;
              }
            });
          },
          // indicatorColor: Colors.amber,

          selectedIndex: _selectedIndex,
          animationDuration: const Duration(milliseconds: 500),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Symbols.book_2_rounded),
              selectedIcon: Icon(Symbols.book_2_rounded, fill: 1),
              label: 'Books',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required int selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Image.asset(
              "assets/images/logo_base.png",
              fit: BoxFit.contain,
              cacheHeight: 100,
              cacheWidth: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Image.asset(
              "assets/images/logo_text.png",
              height: 18,
              fit: BoxFit.contain,
              cacheHeight: 80,
              cacheWidth: 430,
            ),
          ),
        ],
      ),
    );
  }
}
