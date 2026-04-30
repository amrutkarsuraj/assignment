import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';

import 'package:hive/hive.dart';

import '../../data/datasource/recipe_local_ds.dart';
import '../../data/datasource/recipe_remote_ds.dart';
import '../../data/repository/recipe_repository_impl.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final networkProvider = Provider((ref) => NetworkInfo());

final localDataSourceProvider = Provider(
      (ref) => RecipeLocalDS(Hive.box('recipes')),
);

final remoteDataSourceProvider = Provider(
      (ref) => RecipeRemoteDS(ref.read(apiClientProvider)),
);

final repositoryProvider = Provider(
      (ref) => RecipeRepositoryImpl(
    ref.read(remoteDataSourceProvider),
    ref.read(localDataSourceProvider),
    ref.read(networkProvider),
  ),
);