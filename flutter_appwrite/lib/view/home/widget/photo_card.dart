import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/utils/assets_path.dart';
import 'package:flutter_appwrite/utils/color_palette.dart';

class PhotoCard extends StatefulWidget {
  const PhotoCard({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        placeholder: (context, url) => Image.asset(Assets.movieThumbnail, fit: BoxFit.cover),
        errorWidget: (context, url, error) => Text(
          'Error: $error',
          style: const TextStyle(fontSize: 14, color: ColorPalette.white),
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
