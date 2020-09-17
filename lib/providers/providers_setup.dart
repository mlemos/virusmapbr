import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:virusmapbr/providers/app_state_provider.dart';
import 'package:virusmapbr/providers/health_data_provider.dart';
import 'package:virusmapbr/providers/layers_provider.dart';
import 'package:virusmapbr/providers/location_permissions_provider.dart';
import 'package:virusmapbr/providers/navigation_provider.dart';
import 'package:virusmapbr/providers/news_provider.dart';
import 'package:virusmapbr/providers/session_provider.dart';
import 'package:virusmapbr/providers/updates_provider.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<SessionProvider>(
      create: (_) => SessionProvider(),
  ),
  ChangeNotifierProvider<NavigationProvider>(
      create: (_) => NavigationProvider(),
  ),
  ChangeNotifierProvider<AppStateProvider>(
      create: (_) => AppStateProvider(),
  ),
  ChangeNotifierProvider<LocationPermissionsProvider>(
      create: (_) => LocationPermissionsProvider(),
  ),
  ChangeNotifierProvider<NewsProvider>(
      create: (_) => NewsProvider(),
  ),
];

List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<SessionProvider, HealthDataProvider>(
    create: (_) => HealthDataProvider(),
    update: (_, sessionProvider, healthDataProvider) =>
        healthDataProvider..update(sessionProvider),
  ),
  ChangeNotifierProxyProvider<HealthDataProvider, UpdatesProvider>(
    create: (_) => UpdatesProvider(),
    update: (_, healthDataProvider, updatesProvider) =>
        updatesProvider..update(healthDataProvider),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  ChangeNotifierProvider.value(value: LayersProvider()),
];
