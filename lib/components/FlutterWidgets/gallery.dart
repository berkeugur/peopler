import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../core/constants/app/animations_constants.dart';

class PeoplerGallery {
  void openGallery({required BuildContext context, required List<String> images, required int currentIndex, required bool isNetworkImage}) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.mainKey.currentState?.push(MaterialPageRoute(
      builder: (context) => GalleryWidget(
        images: images,
        currentIndex: currentIndex,
        isNetworkImage: isNetworkImage,
      ),
    ));
  }
}

class GalleryWidget extends StatefulWidget {
  ///local image path or network image url
  final List<String> images;
  final bool isNetworkImage;
  final int currentIndex;
  final PageController pageController;
  GalleryWidget({Key? key, required this.images, this.currentIndex = 0, required this.isNetworkImage})
      : pageController = PageController(initialPage: currentIndex),
        super(key: key);

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  late int index = widget.currentIndex;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: PeoplerAppBars(context: context).GALLERY(),
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            PhotoViewGallery.builder(
              loadingBuilder: (context, event) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Lottie.asset(
                      AnimationsConstants.LOADING_PATH,
                      repeat: true,
                      width: 100,
                    ),
                  ),
                );
              },
              pageController: widget.pageController,
              itemCount: widget.images.length,
              builder: (context, index) {
                final _image = widget.images[index];
                return PhotoViewGalleryPageOptions(
                  imageProvider: (widget.isNetworkImage == false ? AssetImage(_image) : NetworkImage(_image)) as ImageProvider?,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 3,
                );
              },
              onPageChanged: (index) {
                setState(() {
                  this.index = index;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Fotoğraf ${this.index + 1}/${widget.images.length}",
                style: PeoplerTextStyle.normal.copyWith(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
