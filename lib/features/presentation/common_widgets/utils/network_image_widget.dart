import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? placeholderIconSize;

  const NetworkImageWidget({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.borderRadius,
    this.placeholderIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: url,
      fit: BoxFit.cover,
      imageBuilder:
          (context, imageProvider) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
      placeholder:
          (context, url) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
              color: Colors.grey.shade200,
            ),
            child: Center(
              child: Icon(
                Icons.restaurant_menu,
                size: placeholderIconSize ?? 60,
                color: Colors.blueGrey.shade200,
              ),
            ),
          ),
      errorWidget:
          (context, url, error) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
              color: Colors.grey.shade200,
            ),
            child: Center(
              child: Icon(Icons.notes_rounded),
              // Image.asset(
              //   LocalAssets.logoBlack,
              //   height: placeholderIconSize ?? 60,
              //   color: Colors.blueGrey.shade200,
              // ),
            ),
          ),
    );
  }
}
