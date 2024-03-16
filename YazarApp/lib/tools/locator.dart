import 'package:get_it/get_it.dart';
import 'package:sqlite_yaxar_projesi/repository/database_repository.dart';
import 'package:sqlite_yaxar_projesi/service/sqflite/sqflite_database_service.dart';

GetIt locator = GetIt.instance;


setupLocator(){
  locator.registerLazySingleton(() => DatabaseRepository());
  locator.registerLazySingleton(() => SqfliteDatabaseService());

}