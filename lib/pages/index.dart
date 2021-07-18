import 'package:flutter/material.dart';
import 'package:google_docs_clone/components/FileExplorer.dart';
import 'package:google_docs_clone/components/TemplateArea.dart';
import 'package:provider/provider.dart';

import 'package:google_docs_clone/components/Header.dart';
import 'package:google_docs_clone/providers/index_page_provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Provider.of<IndexPageProvider>(context, listen: false)
            .searchFocus(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 70),
                  TemplateArea(),
                  FileExplorer(),
                  SizedBox(height: 150),
                ],
              ),
            ),
            Header(),
          ],
        ),
      ),
    );
  }
}
