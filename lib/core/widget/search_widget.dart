import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/core/routes/navigation_service.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/utils/decore_utils.dart';
import 'package:weather_app/dashboard/presentation/cubit/search_location_cubit.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchCtr = TextEditingController();

  @override
  void dispose() {
    _searchCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.arrow_back)
            .onTap(() => getIt<NavigationService>().goBack())
            .padRight(right: 10.w),
        Expanded(
          child: SizedBox(
            height: 40.h,
            child: TextFormField(
              cursorColor: AppColors.blackColor,
              controller: _searchCtr,
              onFieldSubmitted: (value) =>
                  getIt<SearchLocationCubit>().search(query: value),
              decoration: inputDecoration(
                context: context,
                hintText: 'search',
                suffixIcon: Icon(Icons.search, size: 25.w).onTap(
                  () => getIt<SearchLocationCubit>().search(
                    query: _searchCtr.text.trim(),
                  ),
                ),
                borderRadius: 50.r,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
