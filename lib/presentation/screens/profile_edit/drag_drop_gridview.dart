import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/data/services/storage/firebase_storage_service.dart';
import 'package:peopler/presentation/screens/profile_edit/image_functions.dart';
import 'package:peopler/presentation/screens/profile_edit/profile_edit.dart';

import '../profile/MyProfile/ProfileScreen/profile_screen.dart';

class DragDropGridView extends StatefulWidget {
  const DragDropGridView({Key? key}) : super(key: key);

  @override
  State<DragDropGridView> createState() => _DragDropGridViewState();
}

class _DragDropGridViewState extends State<DragDropGridView> {
  final GlobalKey _draggableKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [
          setStateEditProfile,
          setTheme,
        ],
        builder: (context, x, y) {
          print(images2.length);
          print(UserBloc.user!.photosURL.length);
          print("***************uzuadasdğ****************");
          return images2.length == 0
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: ((images2.length / 3).toInt()) + 1 * (MediaQuery.of(context).size.width / 3) * 4 / 3,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 4 / 3,
                    children: List.generate(1, (index) {
                      return addNewContainer(context);
                    }),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: ((images2.length / 3).toInt()) + 1 * (MediaQuery.of(context).size.width / 3) * 4 / 3,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 4 / 3,
                    children: List.generate(images2.length + 1, (index) {
                      var _image = images2[index == images2.length ? index - 1 : index];
                      bool isLastIndex = index == images2.length ? true : false;
                      return _buildGridViewItem(context, _image, isLastIndex, index);
                    }),
                  ),
                );
        });
  }

  Widget _buildGridViewItem(BuildContext context, _image, bool isLastIndex, int index) {
    return isLastIndex == true
        ? addNewContainer(context)
        : Stack(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width / 3) * 4 / 3,
                height: (MediaQuery.of(context).size.width / 3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.5),
                  child: _image.runtimeType.toString() == "String"
                      ? Image.network(
                          _image,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Emin Misiniz?'), // App Permission Settings
                            content: const Text('Bu fotoğraf kalıcı olarak silinecektir.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('İptal'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FirebaseStorage.instance.refFromURL(UserBloc.user!.photosURL[index]).delete();
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(UserBloc.user!.userID)
                                      .update({
                                    "photosURL": FieldValue.arrayRemove([UserBloc.user!.photosURL[index]])
                                  });

                                  images2.removeAt(images2.indexWhere((i) => i == _image));

                                  UserBloc.user!.photosURL.removeAt(index);

                                  Future.delayed(Duration(seconds: 1), () {
                                    setStateEditProfile.value = !setStateEditProfile.value;
                                  }).then((value) => setStateEditProfile.value = !setStateEditProfile.value);

                                  Future.delayed(Duration(milliseconds: 500), () {
                                    setStateValue.value = !setStateValue.value;
                                  }).then(
                                    (value) => setStateValue.value = !setStateValue.value,
                                  );

                                  Navigator.pop(context);
                                },
                                child: const Text('Devam Et'),
                              )
                            ],
                          ));
                  //print("delete button pressed ${_image}");
                  //images2.removeAt(images2.indexWhere((i) => i == _image));
                  //setState(() {});
                },
                borderRadius: BorderRadius.circular(99),
                child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(color: Color(0xFF0353EF), width: 1),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete,
                        size: 12,
                        color: Color(0xFF0353EF),
                      ),
                    )),
              ),
            ],
          );

    /* DRAG DROP İSTEMEDİĞİM İÇİN COMMENTLEDİM.... İLERİDE KULLANABİLİRİZ.
        DragTarget<PhotoData>(
            //
            onAccept: (selectedData) {
            PhotoData _data = selectedData;
            print("onAccept data number ${_data.number}, _image number ${_image.number}");

            //alttaki fonksiyon images listesinin içinde seçilen resmin hangi indexte olduğunu söyler
            int selectedDataIsWhereImageList = images.indexWhere((i) => i.number == _data.number);

            //alttaki fonksiyon images listesinin içinde üzerine sürüklenip bırakılan resmin hangi indete olduğunu söyler
            int droppedDataIsWhereImageList = images.indexWhere((i) => i.number == _image.number);

            //alttaki fonksiyonlar resimlerin yer değişmesini sağlar.
            PhotoData _droppedImageData = images[droppedDataIsWhereImageList];

            images[droppedDataIsWhereImageList] = images[selectedDataIsWhereImageList];
            images[selectedDataIsWhereImageList] = _droppedImageData;

            print("selected: $selectedDataIsWhereImageList, dropped: $droppedDataIsWhereImageList");

            setState(() {});
          },

            //
            onWillAccept: (PhotoData? data) {
            bool _isDataHere = data == null ? false : true;
            print("onWillAccept : isDataHere $_isDataHere and data info: ${data != null ? data.number : 404}");
            return _isDataHere;
          },
            //

            builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return LongPressDraggable<PhotoData>(
              data: _image,
              dragAnchorStrategy: pointerDragAnchorStrategy,
              feedback: DraggingListItem(
                dragKey: _draggableKey,
                image: _image.image,
              ),
              child: _dragableItem(context, _image),
            );
          });
*/
  }

  Container addNewContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 8,
      ),
      width: MediaQuery.of(context).size.width / 3,
      height: (MediaQuery.of(context).size.width / 3) * 4 / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.5),
        border: Border.all(width: 1, color: Color(0xFF0353EF)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          print("yeni ekle...");
          showPickerForAddPhotos(context, stateSetter: setState);
        },
        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  color: Color(0xFF0353EF),
                ),
                Text(
                  "Yeni Ekle",
                  style: GoogleFonts.rubik(color: Color(0xFF0353EF)),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _feedBack(BuildContext context, PhotoData _image) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.5),
        child: _image.image.runtimeType.toString() == "String"
            ? Image.network(
                _image.image,
                fit: BoxFit.fitWidth,
              )
            : Image.file(
                _image.image,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Stack _dragableItem(BuildContext context, PhotoData _image) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: (MediaQuery.of(context).size.width / 3) * 4 / 3,
              height: (MediaQuery.of(context).size.width / 3),
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.5),
                child: _image.image.runtimeType.toString() == "String"
                    ? Image.network(
                        _image.image,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _image.image,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border.all(color: Color(0xFF0353EF), width: 1),
              ),
              child: Text(
                images.indexWhere((i) => i.number == _image.number).toString(),
                style: GoogleFonts.rubik(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0353EF),
                ),
                //_image.number.toString(),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            print("delete button pressed ${_image.number}");
            images.removeAt(images.indexWhere((i) => i.number == _image.number));
            setState(() {});
          },
          borderRadius: BorderRadius.circular(99),
          child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border.all(color: Color(0xFF0353EF), width: 1),
              ),
              child: const Center(
                child: Icon(
                  Icons.delete,
                  size: 12,
                  color: Color(0xFF0353EF),
                ),
              )),
        ),
      ],
    );
  }
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    Key? key,
    required this.dragKey,
    required this.image,
  }) : super(key: key);

  final GlobalKey dragKey;
  final dynamic image;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return FractionalTranslation(
            translation: const Offset(-0.5, -0.5),
            child: ClipRRect(
              key: dragKey,
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                width: (MediaQuery.of(context).size.width / 2.5) * 4 / 3,
                height: MediaQuery.of(context).size.width / 2.5,
                child: Opacity(
                  opacity: 1,
                  child: image.runtimeType.toString() == "String"
                      ? Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          );
        });
  }
}
