import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/helper/basehelper.dart';

CachedNetworkImage cacheNetworkWidget(BuildContext context,
    {required String imageUrl, BoxFit? fit}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: fit ?? BoxFit.cover,
    errorListener: (value) {
      log(value.toString());
    },
    useOldImageOnUrlChange: false,
    progressIndicatorBuilder: (_, url, progress) {
      return Container(
    
        height: 30,
    
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8.0),
        child: BaseHelper.loadingWidget(value: progress.progress),
      );
    },
    errorWidget: (context, url, error) {
      if (error is SocketException) {
        // Handle SocketException here
        return const Text(
            'Error: Failed to load image. Check your internet connection.');
      } else {
        return const Icon(Icons.error);
      }
    },
  );
}

ImageProvider<CachedNetworkImageProvider> cachedNetworkImageProvider({
  required String imageUrl,
}) {
  return CachedNetworkImageProvider(
    imageUrl,
  );
}
