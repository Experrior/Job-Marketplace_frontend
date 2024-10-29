import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:job_search_app/core/injection/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,

)
void configureDependencies() => getIt.init();