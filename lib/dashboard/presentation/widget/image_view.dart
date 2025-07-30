import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_assets.dart';
import 'package:weather_app/core/utils/uitils.dart';

class ImageView extends StatelessWidget {
  final String url;
  final double size;
  const ImageView({super.key, required this.url, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: fixIconUrl(url),
      height: size.w,
      width: size.w,
      placeholder: (context, url) =>
          Image.asset(AppAssets.appLogo, height: size.w, width: size.w),
      errorWidget: (context, url, error) =>
          Image.asset(AppAssets.appLogo, height: size.w, width: size.w),
    );
  }
}
