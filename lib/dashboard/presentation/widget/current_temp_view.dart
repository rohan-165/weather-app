import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/dashboard/domain/model/weather_model.dart';
import 'package:weather_app/dashboard/presentation/widget/image_view.dart';

class CurrentTempView extends StatelessWidget {
  final Current current;
  final Forecast forecast;
  const CurrentTempView({
    super.key,
    required this.current,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        ImageView(url: current.condition?.icon ?? '', size: 60),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${current.tempC}',
              style: context.textTheme.displayLarge?.copyWith(fontSize: 80.sp),
            ),
            Text('˚C', style: context.textTheme.displayLarge).padTop(top: 10.h),
          ],
        ),

        Text(
          current.condition?.text ?? "",
          style: context.textTheme.headlineLarge,
        ),
      ],
    );
  }
}
