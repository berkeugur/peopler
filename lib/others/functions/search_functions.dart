import 'package:flutter/material.dart';
import '../../others/classes/variables.dart';
import '../strings.dart';

TextEditingController editingController = TextEditingController();

final duplicateItems = List.generate(Strings.cityData.length, (i) => Strings.cityData[i]);
var items = <String>[];

void filterSearchResults(String query, StateSetter setState) {
  List<String> dummySearchList = <String>[];
  dummySearchList.addAll(duplicateItems);
  if (query.isNotEmpty) {
    List<String> dummyListData = <String>[];
    for (String item in dummySearchList) {
      //[ "ğ", "Ğ", "ç", "Ç", "ş", "Ş", "ü", "Ü", "ö", "Ö", "ı", "İ" ]
      if (item
          .replaceAll(" ", "")
          .replaceAll("ğ", "g")
          .replaceAll("Ğ", "G")
          .replaceAll("ç", "c")
          .replaceAll("Ç", "C")
          .replaceAll("ş", "s")
          .replaceAll("Ş", "S")
          .replaceAll("ü", "u")
          .replaceAll("Ü", "U")
          .replaceAll("ö", "o")
          .replaceAll("Ö", "O")
          .replaceAll("ı", "i")
          .replaceAll("İ", "I")
          .toLowerCase()
          .contains(query
              .replaceAll("ğ", "g")
              .replaceAll("Ğ", "G")
              .replaceAll("ç", "c")
              .replaceAll("Ç", "C")
              .replaceAll("ş", "s")
              .replaceAll("Ş", "S")
              .replaceAll("ü", "u")
              .replaceAll("Ü", "U")
              .replaceAll("ö", "o")
              .replaceAll("Ö", "O")
              .replaceAll("ı", "i")
              .replaceAll("İ", "I")
              .toLowerCase())) {
        dummyListData.add(item);
      }
    }
    setState(() {
      items.clear();
      items.addAll(dummyListData);
    });
    return;
  } else {
    setState(() {
      items.clear();
      items.addAll(duplicateItems);
    });
  }
}

var items2 = <String>[];
