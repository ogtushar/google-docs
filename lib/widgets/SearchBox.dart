import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_docs_clone/providers/index_page_provider.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IndexPageProvider>(context);
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: provider.isSearchBoxInFocus ? 5 : 0,
      color: Colors.transparent,
      child: Container(
        height: 64,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: provider.isSearchBoxInFocus ? Colors.white : Color(0xFFF1F3F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Center(
                  child: CupertinoTextField(
                    controller: provider.searchBoxController,
                    onTap: () {
                      provider.searchFocus(true);
                    },
                    cursorColor: Colors.black,
                    cursorWidth: 0.5,
                    style: TextStyle(fontSize: 16),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    placeholder: 'Search',
                    placeholderStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
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
