import 'package:flutter/material.dart';
import 'package:google_docs_clone/pages/index.dart';
import 'package:google_docs_clone/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 250,
              ),
              SizedBox(height: 30),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(40),
                color: Color(0xFF4384F4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .signInWithGoogle();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndexPage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.transparent,
                    ),
                    height: 40,
                    width: 100,
                    child: Center(
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
