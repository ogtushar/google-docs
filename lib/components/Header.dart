import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_docs_clone/pages/login.dart';
import 'package:google_docs_clone/providers/auth_provider.dart';
import 'package:google_docs_clone/widgets/SearchBox.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.menu, size: 28),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Image.asset(
                    'assets/images/docs.png',
                    height: 42,
                    width: 42,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Docs',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF5f6368),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SearchBox(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.apps, size: 28),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Tooltip(
                    message: 'logout',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .signOutWithGoogle();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              FirebaseAuth.instance.currentUser?.photoURL ??
                                  "https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Y3V0ZSUyMGNhdHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
