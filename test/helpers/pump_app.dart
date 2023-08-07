import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_hub/l10n/l10n.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpRoute(
    Route<dynamic> route, {
    List<RepositoryProvider<dynamic>> providers = const [],
  }) {
    final child = MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Navigator(onGenerateInitialRoutes: (_, __) => [route]),
    );

    return pumpApp(
      providers.isEmpty
          ? child
          : MultiRepositoryProvider(
              providers: providers,
              child: child,
            ),
    );
  }

  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}
