import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_docs_clone/pages/text_editor.dart';
import 'package:timeago/timeago.dart' as timeago;

class FileExplorer extends StatefulWidget {
  const FileExplorer({Key? key}) : super(key: key);

  @override
  _FileExplorerState createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  final TextEditingController renameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 1100
            ? MediaQuery.of(context).size.width * 0.168
            : 30,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("userDocs")
            .doc(FirebaseAuth.instance.currentUser?.email)
            .collection("docs")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data?.docs.length != 0) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 21, bottom: 19),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "My Documents",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              "Date Created",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.folder_open_outlined,
                                  size: 28,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ...snapshot.data?.docs.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return ListTile(
                          key: Key(document.id),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          title: Text(
                            data['fileName'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          leading: Image.asset(
                            "assets/icons/word.ico",
                            height: 20,
                            width: 20,
                          ),
                          trailing: Container(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  timeago.format(data['timestamp'].toDate()),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      offset: Offset(65, 50),
                                      icon: Icon(
                                        Icons.more_vert,
                                        size: 28,
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Icon(Icons.text_fields),
                                                SizedBox(width: 20),
                                                Text("Rename"),
                                              ],
                                            ),
                                          ),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete),
                                                SizedBox(width: 20),
                                                Text("Remove"),
                                              ],
                                            ),
                                          ),
                                          value: 2,
                                        ),
                                      ],
                                      onSelected: (action) async {
                                        switch (action) {
                                          case 1:
                                            renameController.text =
                                                data['fileName'];
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Container(
                                                    height: 80,
                                                    width: 100,
                                                    color: Colors.white,
                                                    child: Column(
                                                      children: [
                                                        CupertinoTextField(
                                                          controller:
                                                              renameController,
                                                          autofocus: true,
                                                        ),
                                                        SizedBox(height: 20),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text(
                                                                "Cancel",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (renameController
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "userDocs")
                                                                      .doc(FirebaseAuth
                                                                          .instance
                                                                          .currentUser
                                                                          ?.email)
                                                                      .collection(
                                                                          "docs")
                                                                      .doc(document
                                                                          .id)
                                                                      .update(
                                                                    {
                                                                      "fileName": renameController
                                                                          .text
                                                                          .trim(),
                                                                    },
                                                                  );
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              },
                                                              child: Text(
                                                                'OK',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                            break;
                                          case 2:
                                            await FirebaseFirestore.instance
                                                .collection("userDocs")
                                                .doc(FirebaseAuth.instance
                                                    .currentUser?.email)
                                                .collection("docs")
                                                .doc(document.id)
                                                .delete();
                                            break;
                                          default:
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          hoverColor: Color(0xFFE8F0FE),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    TextEditor(docId: document.id),
                              ),
                            );
                          },
                        );
                      },
                    ).toList() ??
                    [],
              ],
            );
          }
          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 21, bottom: 19),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "My Documents",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            "Date Created",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.folder_open_outlined,
                                size: 28,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  "No files",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
