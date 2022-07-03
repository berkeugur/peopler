import 'package:flutter/material.dart';

import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../others/classes/variables.dart';
import '../../presentation/screens/LoginAndRegisterScreen/il_ilce_data.dart';

TextEditingController editingController = TextEditingController();

final duplicateItems = List.generate(cityAndDistrictData.length, (i) => cityAndDistrictData[i][0][0]);
var items = <String>[];

void filterSearchResults(String query, StateSetter setState) {
  List<String> dummySearchList = <String>[];
  dummySearchList.addAll(duplicateItems);
  if (query.isNotEmpty) {
    List<String> dummyListData = <String>[];
    for (var item in dummySearchList) {
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

var duplicateItems2 = List.generate(
    cityAndDistrictData[selectedCityIndex][1].length, (i) => cityAndDistrictData[selectedCityIndex][1][i]);
var items2 = <String>[];
