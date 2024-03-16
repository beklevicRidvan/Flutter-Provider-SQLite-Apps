import 'package:flutter/cupertino.dart';

class Kitap with ChangeNotifier{
  dynamic  id;
  String isim;
  DateTime olusturulmaTarihi;
  int kategori;
  bool seciliMi = false;

  Kitap(this.isim,this.olusturulmaTarihi,this.kategori);

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "isim":isim,
      "olusturulmaTarihi":olusturulmaTarihi,
      "kategori":kategori
    };
  }

  Kitap.fromMap(Map<String,dynamic> kitap):
      id=kitap["id"],
      isim=kitap["isim"],
      olusturulmaTarihi = kitap["olusturulmaTarihi"],
  kategori = kitap["kategori"];


  void guncelle(String yeniIsim,int yeniKategori){
    isim=yeniIsim;
    kategori = yeniKategori;
    notifyListeners();
  }

  void sec(bool yeniDeger){
    seciliMi = yeniDeger;
    notifyListeners();
  }
}