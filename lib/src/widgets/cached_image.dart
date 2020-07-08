import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/src/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CachedImage extends StatelessWidget {
  final String url;

  const CachedImage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) {
          return Center(
            child: SpinKitRipple(
              color: blueColor,
            ),
          );
        },
      ),
    );
  }
}
