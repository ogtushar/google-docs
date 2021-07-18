import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:fluttertoast/fluttertoast.dart';

class TextEditor extends StatefulWidget {
  final String docId;
  const TextEditor({Key? key, required this.docId}) : super(key: key);

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  QuillController? _controller;
  final FocusNode _focusNode = FocusNode();
  DocumentSnapshot? result;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      result = await FirebaseFirestore.instance
          .collection('userDocs')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .collection('docs')
          .doc(widget.docId)
          .get();
      final doc = Document.fromJson(result!['data']);
      setState(() {
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    } catch (error) {
      final doc = Document()..insert(0, '');
      setState(() {
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 70,
            color: Colors.white,
            padding: EdgeInsets.all(8),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        padding: EdgeInsets.only(left: 8),
                        icon: Icon(Icons.arrow_back_ios, size: 22),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 15),
                        Image.asset(
                          'assets/images/docs.png',
                          height: 42,
                          width: 42,
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 3),
                              child: Text(
                                result!['fileName'] ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF5f6368),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection("userDocs")
                                    .doc(FirebaseAuth
                                        .instance.currentUser?.email)
                                    .collection("docs")
                                    .doc(widget.docId)
                                    .update({
                                  "data":
                                      _controller?.document.toDelta().toJson()
                                }).then((value) {
                                  Fluttertoast.showToast(msg: 'File Saved');
                                });
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF5f6368),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Spacer(),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {},
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
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_controller != null) _buildToolbar(context),
          if (_controller != null) _buildEditorArea(context)
        ],
      ),
    );
  }

  _buildToolbar(BuildContext context) {
    var toolbar = QuillToolbar.basic(
      controller: _controller!,
      showCamera: false,
    );
    return Container(
      constraints: BoxConstraints(maxHeight: 200),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      child: toolbar,
    );
  }

  _buildEditorArea(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool largeScreen = size.width >= 1100;
    var quillEditor = QuillEditor(
      controller: _controller!,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: true,
      readOnly: false,
      expands: true,
      padding: EdgeInsets.zero,
    );

    return Expanded(
      flex: 15,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: largeScreen ? 200 : 50,
          right: largeScreen ? 200 : 50,
          top: 30,
        ),
        child: quillEditor,
      ),
    );
  }
}
