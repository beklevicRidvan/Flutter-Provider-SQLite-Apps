import 'package:sqlite_yaxar_projesi/base/database_base.dart';
import 'package:sqlite_yaxar_projesi/model/bolum_model.dart';
import 'package:sqlite_yaxar_projesi/model/kitap_model.dart';
import 'package:sqlite_yaxar_projesi/service/base/database_service.dart';
import 'package:sqlite_yaxar_projesi/service/sqflite/sqflite_database_service.dart';
import 'package:sqlite_yaxar_projesi/tools/locator.dart';

class DatabaseRepository implements  DatabaseBase{

  final DatabaseService _service= locator<SqfliteDatabaseService>();


  @override
  Future createKitap(Kitap kitap) async{
    return await _service.createKitap(kitap);
  }

  @override
  Future<List<Kitap>> readTumKitaplar(int kategoriId, sonKitapId) async{
    return await _service.readTumKitaplar(kategoriId, sonKitapId);
  }

  @override
  Future<int> updateKitap(Kitap kitap) async{
    return await _service.updateKitap(kitap);
  }

  @override
  Future<int> deleteKitap(Kitap kitap) async{
    return await _service.deleteKitap(kitap);
  }

  @override
  Future<int> deleteSeciliKitaplar(List seciliKitapIdleri) async{
    return await _service.deleteSeciliKitaplar(seciliKitapIdleri);
  }

  @override
  Future createBolum(Bolum bolum) async{
    return await _service.createBolum(bolum);
  }
  @override
  Future<List<Bolum>> readTumBolumler(kitapId) async{
    return await _service.readTumBolumler(kitapId);
  }

  @override
  Future<int> updateBolum(Bolum bolum) async{
    return await _service.updateBolum(bolum);
  }
  @override
  Future<int> deleteBolum(Bolum bolum) async{
    return await _service.deleteBolum(bolum);
  }


  
}