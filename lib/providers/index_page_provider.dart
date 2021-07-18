
import 'package:flutter/cupertino.dart';

class IndexPageProvider extends ChangeNotifier {
  bool isSearchBoxInFocus = false;
  TextEditingController searchBoxController = TextEditingController();

  searchFocus(bool val) {
    this.isSearchBoxInFocus = val;
    notifyListeners();
  }
}
