import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/collection_repository.dart';
import '../services/image_storage_service.dart';

/// Overridden in `main()` once the database has finished opening.
final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  throw UnimplementedError('collectionRepositoryProvider not overridden');
});

final imageStorageServiceProvider = Provider<ImageStorageService>((ref) {
  return ImageStorageService();
});
