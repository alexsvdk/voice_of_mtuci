import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/src/features/permissions/managers/permissions_manager.dart';

final permissionsManagerProvider =
    Provider<PermissionsManager>((ref) => PermissionsManager());
