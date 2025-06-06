import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_pwa/location/location_service.dart';

part 'location_providers.g.dart';

@riverpod
LocationService locationService(Ref ref) => LocationService();
