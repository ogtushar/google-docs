import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_docs_clone/pages/index.dart';
import 'package:google_docs_clone/pages/login.dart';
import 'package:google_docs_clone/providers/auth_provider.dart';
import 'package:google_docs_clone/providers/index_page_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.setPersistence(Persistence.SESSION);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndexPageProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google Docs Clone',
        home: App(pageName: "index"),
      ),
    ),
  );
}

class App extends StatelessWidget {
  final String pageName;
  const App({Key? key, required this.pageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (pageName == "index" && isUserLoggedIn) {
      return IndexPage();
    }
    return LoginPage();
  }
}
