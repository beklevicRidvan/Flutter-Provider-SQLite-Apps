import 'package:flutter/foundation.dart';
import 'package:sqlite_yaxar_projesi/repository/database_repository.dart';
import '../model/bolum_model.dart';
import '../tools/locator.dart';

class BolumDetayViewModel with ChangeNotifier{
  final Bolum _bolum;

  final DatabaseRepository _databaseRepository = locator<DatabaseRepository>();


  Bolum get bolum => _bolum;

  BolumDetayViewModel(this._bolum);


  void icerigiKaydet(String icerik) async {
    _bolum.icerik = icerik;

    await _databaseRepository.updateBolum(_bolum);

  }
}