import '../model/bolum_model.dart';
import '../model/kitap_model.dart';

abstract class DatabaseBase{
  Future<dynamic> createKitap(Kitap kitap);
  Future<List<Kitap>> readTumKitaplar(int kategoriId,dynamic sonKitapId);
  Future<int> updateKitap(Kitap kitap);
  Future<int> deleteKitap(Kitap kitap);
  Future<int> deleteSeciliKitaplar(List<dynamic> seciliKitapIdleri);


  Future<dynamic> createBolum(Bolum bolum);
  Future<List<Bolum>> readTumBolumler(dynamic kitapId);
  Future<int> updateBolum(Bolum bolum);
  Future<int> deleteBolum(Bolum bolum);

}