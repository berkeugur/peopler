import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/il_ilce_data.dart';

// ignore: must_be_immutable
class CreateFakeUsersAndFeeds extends StatelessWidget {

  List<String> gender = ["Kadın", "Erkek", "Diğer"];
  List<String> maleNameAndSurname = ["Ali", "Veli", "Mehmet", "Hakan", "Mert", "Mehmet", "Oğuzhan"];
  List<String> femaleNameAndSurname = ["Ayşe", "Fatma", "Handan", "Hayriye", "Merve"];
  List<String> biography = [
    "deneme biography 1",
    "deneme biography 2",
    "deneme biography 3",
    "deneme biography 4",
    "deneme biography 5",
  ];

  List<String> maleProfileURL = [
    "https://randomuser.me/api/portraits/men/35.jpg",
    "https://randomuser.me/api/portraits/men/89.jpg",
    "https://randomuser.me/api/portraits/men/45.jpg",
  ];
  List<String> femaleProfileURL = [
    "https://randomuser.me/api/portraits/women/11.jpg",
    "https://randomuser.me/api/portraits/women/63.jpg",
    "https://randomuser.me/api/portraits/women/10.jpg",
  ];

  List<String> fakeFeedText = [
    "fake feed 1",
    "fake feed 2",
    "fake feed 3",
    "fake feed 4",
    "fake feed 5",
    "fake feed 6",
    "fake feed 7",
  ];

  CreateFakeUsersAndFeeds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int random(min, max) {
      return min + Random().nextInt(max - min);
    }
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    CollectionReference feeds = FirebaseFirestore.instance.collection('feeds');

    Future<void> addUser() {
      int _fakeFeedIndex = random(0, fakeFeedText.length);

      late int  _nameAndSurnameRandomIndex;
      var  _genderRandomIndex = random(0, gender.length);

      int _cityIndex = random(0, 80);
      int _districtIndex = random(0, cityAndDistrictData[_cityIndex][1].length);

      int _biographyIndex = random(0, biography.length);

      int _subtractDayIndex = random(0, 80);
      int _subtractSecongIndex = random(0, 80000);

      if(_genderRandomIndex == 0 && femaleNameAndSurname.length>0){
        _nameAndSurnameRandomIndex = random(0, femaleNameAndSurname.length);
      }else if(_genderRandomIndex == 0 && femaleNameAndSurname.length==0){
        _genderRandomIndex = 1;
      }
      else if(_genderRandomIndex == 1 && maleNameAndSurname.length>0){
        _nameAndSurnameRandomIndex = random(0, maleNameAndSurname.length);
      }else if(_genderRandomIndex == 1 && maleNameAndSurname.length==0){
        _genderRandomIndex =2;
      }else if(_genderRandomIndex == 2 && maleNameAndSurname.length>0){
        _nameAndSurnameRandomIndex = random(0, maleNameAndSurname.length);
      }else{
        print("Listeler boşaldı listelere isim girin");
      }

      if(_genderRandomIndex == 0 && femaleProfileURL.length>0){
        _nameAndSurnameRandomIndex = random(0, femaleProfileURL.length);
      }else if(_genderRandomIndex == 0 && femaleProfileURL.length==0){
        _genderRandomIndex = 1;
      }
      else if(_genderRandomIndex == 1 && maleProfileURL.length>0){
        _nameAndSurnameRandomIndex = random(0, maleProfileURL.length);
      }else if(_genderRandomIndex == 1 && maleProfileURL.length==0){
        _genderRandomIndex =2;
      }else if(_genderRandomIndex == 2 && maleProfileURL.length>0){
        _nameAndSurnameRandomIndex = random(0, maleProfileURL.length);
      }else{
        print("Listeler boşaldı listelere isim girin");
      }

      String profileURLFunction(){
        if(_genderRandomIndex == 0){
          return femaleProfileURL[_nameAndSurnameRandomIndex].toString();
        }else if(_genderRandomIndex == 1){
          return maleProfileURL[_nameAndSurnameRandomIndex].toString();
        }else if (_genderRandomIndex == 2){
          return maleProfileURL[_nameAndSurnameRandomIndex].toString();
        }else{
          return "error name";
        }
      }



      String pplNameFunction() {
        int _pplNameRandomNumber = random(0, 99999);
        if (_pplNameRandomNumber < 10) {
          return "0000" + _pplNameRandomNumber.toString();
        } else if (_pplNameRandomNumber < 100 && _pplNameRandomNumber > 9) {
          return "000" + _pplNameRandomNumber.toString();
        } else if (_pplNameRandomNumber < 1000 && _pplNameRandomNumber > 99) {
          return "00" + _pplNameRandomNumber.toString();
        } else if (_pplNameRandomNumber < 10000 && _pplNameRandomNumber > 999) {
          return "0" + _pplNameRandomNumber.toString();
        } else if (_pplNameRandomNumber < 100000 && _pplNameRandomNumber > 9999) {
          return _pplNameRandomNumber.toString();
        } else {
          return "hata #154785569";
        }
      }

      String nameAndSurnameFunction(){
        if(_genderRandomIndex == 0){
          return femaleNameAndSurname[_nameAndSurnameRandomIndex].toString();
        }else if(_genderRandomIndex == 1){
          return maleNameAndSurname[_nameAndSurnameRandomIndex].toString();
        }else if (_genderRandomIndex == 2){
          return maleNameAndSurname[_nameAndSurnameRandomIndex].toString();
        }else{
          return "error name";
        }
      }

      if(nameAndSurnameFunction() != "error name"){
        return users.add({
          'userID': "",
          'isFake': true,
          'isTheAccountConfirmed' : false,
          'missingInfo': false,
          'displayName': nameAndSurnameFunction(), // John Doe
          'gender': gender[_genderRandomIndex].toString(), // Stokes and Sons
          'pplName': "ppl" + pplNameFunction().toString(), // 42
          'city': cityAndDistrictData[_cityIndex][0][0],
          'district' : cityAndDistrictData[_cityIndex][1][_districtIndex],
          'biography' : biography[_biographyIndex],
          'email' : _subtractDayIndex.toString() + _subtractSecongIndex.toString() + nameAndSurnameFunction() + "@gmail.com",
          'createdAt' : DateTime.now().subtract(Duration(days: _subtractDayIndex,seconds: _subtractSecongIndex,)),
          'updateAt' : DateTime.now(),
          'profileURL' : profileURLFunction(),
        })
            .then((value) {
          value.update({"userID" : value.id});

          feeds.add({
            'createdAt' : DateTime.now().subtract(Duration(seconds: _subtractSecongIndex,)),
            'feedExplanation' :fakeFeedText[_fakeFeedIndex] + "  \n  " + (cityAndDistrictData[_cityIndex][0][0] + "  " + cityAndDistrictData[_cityIndex][1][_districtIndex] + "  " + nameAndSurnameFunction())*3,
            'feedID' : "",
            'updatedAt' : DateTime.now(),
            'userDisplayName' : nameAndSurnameFunction(),
            'userGender' : gender[_genderRandomIndex].toString(),
            'userID' : value.id,
            'userPhotoUrl': profileURLFunction(),
          }).then((value) {
            value.update({"feedID" : value.id});
          }).catchError((error) => print("Failed to add feed: $error"));

          if (_genderRandomIndex == 0) {
            print(femaleNameAndSurname);
            femaleNameAndSurname.removeAt(_nameAndSurnameRandomIndex);
            biography.removeAt(_biographyIndex);
            fakeFeedText.removeAt(_fakeFeedIndex);
            print(femaleNameAndSurname);

            print("kalan kadın ismi sayısı: " + femaleNameAndSurname.length.toString());
            print("kalan erkek ismi sayısı: " + maleNameAndSurname.length.toString());
            print("kalan biyogrofi sayısı: " + biography.length.toString());
            print("kalan kadın fotoğrafı sayısı: " + femaleProfileURL.length.toString());
            print("kalan erkek fotoğrafı sayısı: " + maleProfileURL.length.toString());
            print("kalan fake feed  sayısı: " + fakeFeedText.length.toString());

          } else if (_genderRandomIndex == 1) {
            print(maleNameAndSurname);
            maleNameAndSurname.removeAt(_nameAndSurnameRandomIndex);
            biography.removeAt(_biographyIndex);
            fakeFeedText.removeAt(_fakeFeedIndex);
            print(maleNameAndSurname);

            print("kalan kadın ismi sayısı: " + femaleNameAndSurname.length.toString());
            print("kalan erkek ismi sayısı: " + maleNameAndSurname.length.toString());
            print("kalan biyogrofi sayısı: " + biography.length.toString());
            print("kalan kadın fotoğrafı sayısı: " + femaleProfileURL.length.toString());
            print("kalan erkek fotoğrafı sayısı: " + maleProfileURL.length.toString());
            print("kalan fake feed  sayısı: " + fakeFeedText.length.toString());

          } else {
            print(maleNameAndSurname);
            maleNameAndSurname.removeAt(_nameAndSurnameRandomIndex);
            biography.removeAt(_biographyIndex);
            fakeFeedText.removeAt(_fakeFeedIndex);
            print(maleNameAndSurname);

            print("kalan kadın ismi sayısı: " + femaleNameAndSurname.length.toString());
            print("kalan erkek ismi sayısı: " + maleNameAndSurname.length.toString());
            print("kalan biyogrofi sayısı: " + biography.length.toString());
            print("kalan kadın fotoğrafı sayısı: " + femaleProfileURL.length.toString());
            print("kalan erkek fotoğrafı sayısı: " + maleProfileURL.length.toString());
            print("kalan fake feed  sayısı: " + fakeFeedText.length.toString());

          }
          print("User Added");

        })
            .catchError((error) => print("Failed to add user: $error"));}
      else{
        return Future.delayed(Duration(seconds: 1), ((){print("isim listelerinde eleman kalmadı");}));
      }
    }

    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            print("pressed");
            addUser();
          },
          child: const Text(
            "Add User",
          ),
        ),
      ),
    );
  }
}
