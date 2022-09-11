import 'dart:io';

import 'package:flutter/material.dart';

class PreviewCardWidget extends StatelessWidget {
  final Animation<Offset> previewAnimation;
  final File? image;
  const PreviewCardWidget(
      {Key? key, required this.previewAnimation, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getEmptyImage() {
      return Container(
        width: 128,
        height: 228,
        decoration: const BoxDecoration(
          color: Colors.black38,
        ),
        child: const Center(
          child: Icon(
            Icons.photo,
            color: Colors.white,
          ),
        ),
      );
    }

    Widget getImage(File file) {
      return Image.file(file, width: 128);
    }

    Widget getPreview() {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(2, 2),
              blurRadius: 25,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13.0),
            child: image != null ? getImage(image!) : getEmptyImage(),
          ),
        ),
      );
    }

    return Align(
      alignment: MediaQuery.of(context).orientation == Orientation.landscape
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
      child: Padding(
        padding: MediaQuery.of(context).orientation == Orientation.landscape
            ? const EdgeInsets.only(right: 120.0, bottom: 10)
            : const EdgeInsets.only(left: 20, bottom: 120),
        child: Dismissible(
            key: UniqueKey(),
            child: SlideTransition(
              position: previewAnimation,
              child: getPreview(),
            )),
      ),
    );
  }
}
