import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_docs_clone/pages/text_editor.dart';

class TemplateArea extends StatefulWidget {
  const TemplateArea({Key? key}) : super(key: key);

  @override
  _TemplateAreaState createState() => _TemplateAreaState();
}

class _TemplateAreaState extends State<TemplateArea> {
  final fileNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      color: Color(0xFFF1F3F4),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 1100
            ? MediaQuery.of(context).size.width * 0.168
            : 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Start a new document",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF202124),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.more_vert,
                            size: 28,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Template(
                  imgPath: "assets/images/docs_blank.png",
                  onTap: () {
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
                                  controller: fileNameController,
                                  placeholder: "File Name",
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (fileNameController.text
                                            .trim()
                                            .isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection("userDocs")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.email)
                                              .collection("docs")
                                              .add(
                                            {
                                              "fileName": fileNameController
                                                  .text
                                                  .trim(),
                                              "data":
                                                  json.encode({'insert': 0}),
                                              "timestamp":
                                                  FieldValue.serverTimestamp()
                                            },
                                          ).then((value) {
                                            fileNameController.text = "";
                                            Navigator.pop(context);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TextEditor(docId: value.id),
                                              ),
                                            );
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Create',
                                        style: TextStyle(
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
                  },
                  name: "Blank",
                ),
                SizedBox(width: 20),
                Template(
                  imgPath: "assets/images/docs_resume1.png",
                  onTap: () {},
                  name: "Resume",
                ),
                SizedBox(width: 20),
                Template(
                  imgPath: "assets/images/docs_resume2.png",
                  onTap: () {},
                  name: "Resume",
                ),
                SizedBox(width: 20),
                Template(
                  imgPath: "assets/images/docs_letter.png",
                  onTap: () {},
                  name: "Letter",
                ),
                SizedBox(width: 20),
                Template(
                  imgPath: "assets/images/docs_prj.png",
                  onTap: () {},
                  name: "Project proposal",
                ),
                SizedBox(width: 20),
                Template(
                  imgPath: "assets/images/docs_brochure.png",
                  onTap: () {},
                  name: "Brochure",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Template extends StatefulWidget {
  final String imgPath;
  final Function() onTap;
  final String name;

  const Template({
    Key? key,
    required this.imgPath,
    required this.onTap,
    required this.name,
  }) : super(key: key);

  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: widget.onTap,
          onHover: (val) {
            setState(() {
              isHovering = val;
            });
          },
          child: Container(
            height: 190,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: isHovering ? Colors.blue : Colors.grey.shade400,
                width: 0.5,
              ),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(widget.imgPath),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: Center(
            child: Text(
              widget.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF202124),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
