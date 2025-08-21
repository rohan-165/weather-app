import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/bloc/app_open_cubit.dart';
import 'package:weather_app/core/bloc/location_cubit.dart';
import 'package:weather_app/core/bloc/theme_cubit.dart';
import 'package:weather_app/core/env/get_env_config.dart';
import 'package:weather_app/core/routes/navigation_service.dart';
import 'package:weather_app/core/routes/route_generator.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/services/isolate_service.dart';
import 'package:weather_app/core/theme/dark_theme.dart';
import 'package:weather_app/core/theme/light_theme.dart';
import 'package:weather_app/core/utils/debug_log_utils.dart';
import 'package:weather_app/core/widget/app_exit_widget.dart';
import 'package:weather_app/core/widget/internet_connection_widget.dart';
import 'package:weather_app/dashboard/presentation/screen/weather_screen.dart';
import 'package:weather_app/global_bloc_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    DebugLoggerService.log(
      "Device orientation locked to portrait.",
      level: LogLevel.info,
    );
  } catch (e) {
    DebugLoggerService.log(
      "Failed to lock device orientation: $e",
      level: LogLevel.error,
    );
  }
  try {
    await dotenv.load(fileName: GetEnvConfig.keyEnvironmentFile);
    DebugLoggerService.log(
      "Environment file loaded: ${GetEnvConfig.keyEnvironmentFile}",
      level: LogLevel.success,
    );
  } catch (e) {
    DebugLoggerService.log(
      "Failed to load environment file: $e",
      level: LogLevel.error,
    );
  }
  try {
    await configureDependencies();
    DebugLoggerService.log(
      "Dependencies configured successfully.",
      level: LogLevel.success,
    );
  } catch (e) {
    DebugLoggerService.log(
      "Dependency configuration failed: $e",
      level: LogLevel.error,
    );
  }
  await IsolateService().init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<bool> _isToHide = ValueNotifier<bool>(true);

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    // Initialize the theme and language cubits
    getIt<ThemeCubit>().init();
    getIt<LocationCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: globalBlocProvider(),
      child: BlocBuilder<ThemeCubit, String>(
        builder: (context, theme) {
          return AppExit(
            canPop: false,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  Expanded(
                    child: ScreenUtilInit(
                      designSize: Size(
                        MediaQuery.sizeOf(context).width,
                        MediaQuery.sizeOf(context).height,
                      ),
                      minTextAdapt: true,
                      splitScreenMode: true,
                      builder: (context, child) {
                        return Material(
                          child: MaterialApp(
                            debugShowCheckedModeBanner: false,
                            navigatorKey: NavigationService.navigatorKey,
                            onGenerateRoute: RouteGenerator.generateRoute,
                            darkTheme: darkTheme(context),
                            theme: lightTheme(context),
                            themeMode: theme == ThemeMode.light.name
                                ? ThemeMode.light
                                : ThemeMode.dark,
                            home: WeatherScreen(),

                            title: 'Weather App',
                          ),
                        );
                      },
                    ),
                  ),
                  // This is the widget that handles the internet connection status
                  ValueListenableBuilder(
                    valueListenable: _isToHide,
                    builder: (_, isToHide, __) {
                      return BlocBuilder<AppOpenCubit, bool>(
                        builder: (context, appOpenState) {
                          return InternetConnectionWidget(
                            callBack: (isConnected) {
                              if (isConnected) {
                                if (appOpenState) {
                                  _isToHide.value = true;
                                } else {
                                  // Call your method after 3 seconds
                                  Future.delayed(Duration(seconds: 3), () {
                                    // Set showWidget to true after 3 seconds
                                    _isToHide.value = true;
                                  });
                                }
                              } else {
                                _isToHide.value = false;
                              }
                            },
                            offlineWidget: Align(
                              alignment: Alignment.bottomCenter,
                              child: InternetConnectionMsgWidget(
                                isConnected: false,
                              ),
                            ),
                            onlineWidget: Align(
                              alignment: Alignment.bottomCenter,
                              child: isToHide
                                  ? SizedBox.fromSize()
                                  : InternetConnectionMsgWidget(
                                      isConnected: true,
                                    ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
