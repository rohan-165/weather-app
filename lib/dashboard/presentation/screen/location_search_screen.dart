import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/common/abs_normal_state.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/constants/enum.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/core/routes/navigation_service.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/utils/decore_utils.dart';
import 'package:weather_app/core/widget/loader_widget.dart';
import 'package:weather_app/core/widget/search_widget.dart';
import 'package:weather_app/dashboard/domain/model/search_location_model.dart';
import 'package:weather_app/dashboard/presentation/cubit/search_location_cubit.dart';
import 'package:weather_app/dashboard/presentation/cubit/selected_location_cubit.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: SearchWidget()),
      body:
          BlocBuilder<
            SearchLocationCubit,
            AbsNormalState<List<SearchLocationModel>>
          >(
            builder: (context, searchState) {
              if (searchState.absNormalStatus == AbsNormalStatus.LOADING) {
                return Center(
                  child: LoaderWidget(dotColor: AppColors.blueAccentColor),
                );
              } else if (searchState.absNormalStatus == AbsNormalStatus.ERROR) {
                return Center(
                  child: Text(
                    searchState.failure?.message ?? 'Error',
                    style: context.textTheme.displayLarge,
                  ),
                );
              } else if (searchState.absNormalStatus ==
                  AbsNormalStatus.SUCCESS) {
                return SafeArea(
                  child: (searchState.data ?? []).isNotEmpty
                      ? ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemCount: (searchState.data ?? []).length,
                          separatorBuilder: (context, index) =>
                              10.verticalSpace,
                          itemBuilder: (context, index) {
                            SearchLocationModel location =
                                (searchState.data ?? [])[index];
                            return Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: boxDecoration(
                                context,
                                color: AppColors.whiteColor,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on).padRight(right: 10.w),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: location.name ?? '',
                                        style: context.textTheme.bodyLarge,
                                        children: [
                                          if ((location.region ?? '')
                                              .isNotEmpty) ...{
                                            TextSpan(
                                              text: " ,${location.region}",
                                              style:
                                                  context.textTheme.bodyLarge,
                                            ),
                                          },
                                          TextSpan(
                                            text: " ,${location.country}",
                                            style: context.textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ).onTap(() {
                              getIt<SelectedLocationCubit>().setLocation(
                                value: location.name ?? 'kathmandu',
                              );
                              getIt<SearchLocationCubit>().reset();
                              getIt<NavigationService>().safePop();
                            });
                          },
                        ).padHorizontal(horizontal: 20.w).padTop(top: 10.h)
                      : Center(child: Text("No location found!")),
                );
              } else {
                return Center(child: Text("Search the location"));
              }
            },
          ),
    );
  }
}
