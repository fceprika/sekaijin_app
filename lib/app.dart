import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/theme.dart';
import 'core/config/routes.dart';
import 'core/config/app_config.dart';

class SekaijinApp extends ConsumerWidget {
  const SekaijinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
