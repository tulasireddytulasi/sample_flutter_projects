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
      child: Image.network(
        widget.imageUrl,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.movieThumbnail, fit: BoxFit.cover),
                const SizedBox(height: 10),
                Text(
                  'Error: $error',
                  style: const TextStyle(fontSize: 14, color: ColorPalette.white),
                ),
              ],
            ),
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }
}
