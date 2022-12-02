import 'package:get_it/get_it.dart';
import 'pages/home/home_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // important singletones
  //locator.registerSingleton(DB());

  // services
  //locator.registerLazySingleton(() => CurrentApi());

  //view models
  locator.registerFactory(() => HomeModel());
}
