import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app/core/widget/loader_widget.dart';

class PullToRefreshWidget extends StatelessWidget {
  final Widget child;
  final Function() onRefresh;
  final Function() onLoading;
  PullToRefreshWidget({
    super.key,
    required this.child,
    required this.onRefresh,
    required this.onLoading,
  });
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      onRefresh: () {
        onRefresh();
        _refreshController.refreshCompleted();
      },
      onLoading: () {
        onLoading();
        _refreshController.loadComplete();
      },
      enablePullDown: true,
      enablePullUp: false,
      footer: CustomFooter(
        builder: (context, mode) {
          return const SizedBox.shrink();
        },
      ),
      header: const WaterDropHeader(
        complete: Icon(Icons.check, color: Colors.white),
        waterDropColor: Colors.black,
        refresh: LoaderWidget(),
      ),
      controller: _refreshController,
      child: child,
    );
  }
}
