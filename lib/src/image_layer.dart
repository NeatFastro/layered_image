import 'package:flutter/material.dart';

class ImageLayer extends StatelessWidget {
  final String imageSrc;
  final Offset offset;

  const ImageLayer({
    Key? key,
    required this.imageSrc,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: NetworkImage(imageSrc),
            // fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
