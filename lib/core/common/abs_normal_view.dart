import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app/core/constants/enum.dart';
import 'package:weather_app/core/widget/custom_error_widget.dart';
import 'package:weather_app/core/widget/loader_widget.dart';
import 'package:weather_app/core/widget/no_data_widget.dart';
import 'package:weather_app/core/widget/pull_to_refresh_widget.dart';

class AbsNormalView<T> extends StatelessWidget {
  final bool isToRefresh;
  final Widget? errorWidget;
  final AbsNormalStatus absNormalStatus;
  final T? data;
  final VoidCallback? onRetry;
  final Widget child;

  const AbsNormalView({
    super.key,
    this.isToRefresh = false,
    this.errorWidget,
    required this.absNormalStatus,
    this.data,
    this.onRetry,
    required this.child,
  }) : assert(
         !isToRefresh || onRetry != null,
         'If isToRefresh is true, onRetry must not be null',
       );

  @override
  Widget build(BuildContext context) {
    switch (absNormalStatus) {
      case AbsNormalStatus.LOADING:
      case AbsNormalStatus.INITIAL:
        return const Center(child: LoaderWidget());

      case AbsNormalStatus.ERROR:
        return errorWidget ?? CustomErrorWidget(onRetry: onRetry!);

      case AbsNormalStatus.SUCCESS:
        final isEmptyList = data is List && (data as List).isEmpty;
        if (isEmptyList || data == null) return const NoDataWidget();
        if (isToRefresh) {
          final refreshController = RefreshController(initialRefresh: false);
          return SmartRefresher(
            controller: refreshController,
            onRefresh: () {
              onRetry!();
              refreshController.refreshCompleted();
            },
            child: child,
          );
        }
        return child;
    }
  }
}

class AbsPaginationNormalView<T> extends StatelessWidget {
  final Widget child;
  final Widget? errorWidget;
  final AbsNormalStatus absNormalStatus;
  final T? data;
  final VoidCallback onLoading;
  final VoidCallback onRefresh;

  const AbsPaginationNormalView({
    super.key,
    required this.child,
    this.errorWidget,
    required this.absNormalStatus,
    this.data,
    required this.onLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    switch (absNormalStatus) {
      case AbsNormalStatus.LOADING:
      case AbsNormalStatus.INITIAL:
        return const Center(child: LoaderWidget());

      case AbsNormalStatus.ERROR:
        return errorWidget ?? CustomErrorWidget(onRetry: onRefresh);

      case AbsNormalStatus.SUCCESS:
        final isEmptyList = data is List && (data as List).isEmpty;
        if (isEmptyList || data == null) return const NoDataWidget();

        return PullToRefreshWidget(
          onLoading: onLoading,
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: child,
          ),
        );
    }
  }
}
