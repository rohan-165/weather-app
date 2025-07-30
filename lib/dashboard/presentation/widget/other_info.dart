import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/dashboard/domain/model/weather_model.dart';

class OtherInfo extends StatelessWidget {
  final Current current;
  const OtherInfo({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 1.1,
      crossAxisCount: 3,
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.h,
      children: [
        _container(
          context,
          icon: Icons.wb_sunny,
          lable: 'UV',
          value: '${current.uv} Moderate',
        ),
        _container(
          context,
          icon: Icons.thermostat_outlined,
          lable: 'Feel like',
          value: '${current.feelslikeC}˚',
        ),
        _container(
          context,
          icon: Icons.water_drop_sharp,
          lable: 'Humidity',
          value: '${current.humidity}%',
        ),
        _container(
          context,
          icon: Icons.air_sharp,
          lable: '${current.windDir} Wind',
          value: '${current.windKph} km/h',
        ),
        _container(
          context,
          icon: Icons.keyboard_double_arrow_down_sharp,
          lable: 'Air Pressure',
          value: '${current.pressureMb} hPa',
        ),
        _container(
          context,
          icon: Icons.remove_red_eye_rounded,
          lable: 'Visibility',
          value: '${current.visKm} km',
        ),
      ],
    ).padHorizontal(horizontal: 10.w);
  }

  Widget _container(
    BuildContext context, {
    required String lable,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 28.w),
          Text(
            lable,
            maxLines: 1,
            style: context.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
