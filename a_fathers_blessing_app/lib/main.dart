// import 'package:a_fathers_blessing_app/pages/edit_truth78_blessing_screen.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:a_fathers_blessing_app/controller/all_provs.dart';
import 'package:a_fathers_blessing_app/pages/all_pages.dart';

import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';

import 'package:a_fathers_blessing_app/controller/user/authentication/is_user_logged_in.dart';

import 'controller/config.dart';
import 'package:a_fathers_blessing_app/pages/add_blessing/check_list.dart';

// import 'package:a_fathers_blessing_app/pages/my_blessings_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = await path_provider.getApplicationDocumentsDirectory();

  await Firebase.initializeApp();
  Hive.init(path.path);
  Hive.registerAdapter(MyBlessingAdapter());
  Hive.registerAdapter(TruthBlessingAdapter());
  Hive.registerAdapter(TagAdapter());

  await Hive.openBox(Config.myBlessingBox);
  await Hive.openBox(Config.truthBlessingBox);
  await Hive.openBox(Config.tagBox);
  await Hive.openBox(Config.configBox);

  RemoteConfig(); //sets listeners to fetch config from firestore

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyBlessingProvider()),
        ChangeNotifierProvider(create: (context) => TruthBlessingProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TagProvider()),
        ChangeNotifierProvider(create: (context) => ScriptureProvider()),
      ],
      child: MaterialApp(
          key: GlobalKey(),
          title: 'Home Screen',
          theme: ThemeData(
            primaryColor: const Color(0xFFCF993D),
            secondaryHeaderColor: const Color(0xFF3a6682),
            accentColor: const Color(0xFF507a96),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // initialRoute: '/is_user_logged_in',
          home: Authenticate(),
          routes: {
            '/home': (context) => MyHomePage(),
            '/blessing_menu': (context) => BlessingsMenu(),
            '/truth78_blessing_list': (context) => Truth78BlessingList(),
            '/blessing': (context) => BlessingScreen(),
            '/edit_blessing': (context) =>
                EditMyBlessing(), //, ADD ROUTE TO EDIT MY BLESSING AND UNCOMMENT
            '/edit_truth_blessing': (context) =>
                EditTruthBlessing(), //ADD ROUTE TO EDIT TRUTH BLESSING AND UNCOMMENT
            '/search_blessing': (context) =>
                SearchBlessing(), //ADD ROUTE TO EDIT TRUTH BLESSING AND UNCOMMENT
            '/login_screen': (context) => LoginScreen(),
            '/register_screen': (context) => RegisterScreen(),
            '/selector_page': (context) => SelectorPage(),
            '/my_blessings_list_screen': (context) => MyBlessings(),
            '/add_blessing': (context) =>
                AddBlessing(), //ADD ROUTE TO ADD BLESSING AND UNCOMMENT
            '/help_screen': (context) => HelpScreen(),
            '/about_truth78_screen': (context) => About78(),
            '/other_apps': (context) => OtherApps(),
            '/guide': (context) => GuidePage(),
            '/chapters': (context) => ChaptersScreen(),
            '/tags': (context) => TagScreen(context),
            '/email_verified': (context) => EmailVerified(),
            '/is_user_logged_in': (context) => IsUserLoggedIn(),
            '/select_bible': (context) => SelectBible(),
            '/select_book': (context) => SelectBook(),
            '/select_chapter': (context) => SelectChapter(),
            '/select_verse': (context) => SelectVerse(),
            '/verse_view': (context) => VerseView(),
            '/settings': (context) => Settings(),
            '/test': (context) => VerseSelector()
            // '/my_blessing_list': (context) => MyBlessingsList(), //ADD ROUTE TO ADD BLESSING AND UNCOMMENT
          })));
}

class Authenticate extends StatefulWidget {
  // const Authenticate({ Key? key }) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
    
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final firebaseUser = userProvider.user;

    if (firebaseUser == null) {
      return SelectorPage();
    }
    return MyHomePage();
  }
}