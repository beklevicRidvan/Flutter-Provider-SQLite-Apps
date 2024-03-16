import 'package:sqflite/sqflite.dart';
import 'package:sqlite_yaxar_projesi/model/bolum_model.dart';
import 'package:sqlite_yaxar_projesi/model/kitap_model.dart';
import 'package:path/path.dart';
import 'package:sqlite_yaxar_projesi/service/base/database_service.dart';


class SqfliteDatabaseService implements DatabaseService{

  Database? _veriTabani;

  final String _kitaplarTabloAdi = "kitaplar";
  final String _idKitaplar = "id";
  final String _isimKitaplar = "isim";
  final String _olusturulmaTarihiKitaplar = "olusturulmaTarihi";
  final String _kategoriKitaplar = "kategori";


  final String _bolumlerTabloAdi = "bolumler";
  final String _idBolumler = "id";
  final String _kitapIdBolumler = "kitapId";
  final String _baslikBolumler = "baslik";
  final String _icerikBolumler = "icerik";
  final String _olusturulmaTarihiBolumler = "olusturulmaTarihi";




  Future<Database?> _veriTabaniniGetir() async{
    if(_veriTabani == null){
      String dosyaYolu = await getDatabasesPath();
      String veriTabaniYolu = join(dosyaYolu,"yazar.db");
      _veriTabani = await openDatabase(
        veriTabaniYolu,
        version: 3,
        onCreate:_tabloOlustur,
        onUpgrade: _tabloGuncelle,
      );
    }
    return _veriTabani;
  }
  Future<void> _tabloOlustur(Database db,int version) async{
    await db.execute(
        """
      CREATE TABLE $_kitaplarTabloAdi(
        $_idKitaplar INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
        $_isimKitaplar TEXT NOT NULL,
        $_olusturulmaTarihiKitaplar INTEGER,
        $_kategoriKitaplar INTEGER DEFAULT 0
      );
      """
    );
    await db.execute(
        """
      CREATE TABLE $_bolumlerTabloAdi(
        $_idBolumler INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
        $_kitapIdBolumler INTEGER NOT NULL,
        $_baslikBolumler TEXT NOT NULL,
        $_icerikBolumler TEXT,
        $_olusturulmaTarihiBolumler TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY("$_kitapIdBolumler") REFERENCES "$_kitaplarTabloAdi"("$_idKitaplar") ON UPDATE CASCADE ON DELETE CASCADE      
      );
      """
    );
  }

  Future<void> _tabloGuncelle(Database db, int oldVersion, int newVersion) async
  {


    List<String>  guncellemeKomutlari = [];


    for(int i =oldVersion-1;i<newVersion-1;i++){
      await db.execute(guncellemeKomutlari[i]);
    }

  }

  Map<String,dynamic> _kitapToMap(Kitap kitap){
    Map<String,dynamic> kitapMap = kitap.toMap();
    DateTime? olusturulmaTarihi = kitapMap["olusturulmaTarihi"];
    if(olusturulmaTarihi != null){
      kitapMap["olusturulmaTarihi"] = olusturulmaTarihi.millisecondsSinceEpoch;
    }
    return kitapMap;
  }


  Kitap _mapToKitap(Map<String,dynamic> m){

    Map<String,dynamic> kitapMap = Map.from(m);

    int? olusturulmaTarihi =  kitapMap["olusturulmaTarihi"];
    if(olusturulmaTarihi != null){
      kitapMap["olusturulmaTarihi"] = DateTime.fromMillisecondsSinceEpoch(olusturulmaTarihi);
    }
    return Kitap.fromMap(kitapMap);
  }





  @override
  Future createKitap(Kitap kitap) async{
    Database? db = await _veriTabaniniGetir();

    if(db != null){
      return await  db.insert(_kitaplarTabloAdi, _kitapToMap(kitap));
    }
    else{
      return -1;
    }
  }

  @override
  Future<List<Kitap>> readTumKitaplar(int kategoriId, sonKitapId) async{
    Database? db = await _veriTabaniniGetir();
    List<Kitap> kitaplar = [];

    if(db != null){
      String filtre="$_idKitaplar > ?";
      List<dynamic> filtreArgumanlari=[sonKitapId];


      if(kategoriId>=0){
        filtre  += " and $_kategoriKitaplar = ?";
        filtreArgumanlari.add(kategoriId);
      }

      List<Map<String,dynamic>> kitaplarMap = await db.query(
          _kitaplarTabloAdi,
          where: filtre,
          whereArgs: filtreArgumanlari,
          orderBy: _idKitaplar, // "$_kategoriKitaplar collate localized,$_isimKitaplar desc", // alfabeyi local dile göre günceller collate localized
          limit: 15
        //limit: 3 // filtrereye uyan 3 veriyi getirir,
        //offset: 2, // atlanması gereken veri sayısını veriyoruz baştan 2 veri atlayıp diğerlerini getirir
        // orderBy: "$_idKitaplar desc", limit: 1 // eklenen son veriyi alır
      );
      for(var eleman in kitaplarMap){
        Kitap kitap= _mapToKitap(eleman);
        kitaplar.add(kitap);
      }
    }
    return kitaplar;
  }



  @override
  Future<int> updateKitap(Kitap kitap) async{
    Database? db = await _veriTabaniniGetir();

    if(db != null){
      return await db.update(
        _kitaplarTabloAdi,
        _kitapToMap(kitap),
        where: "$_idKitaplar = ?",
        whereArgs: [kitap.id],
      );
    }
    else{
      return 0;
    }
  }



  @override
  Future<int> deleteKitap(Kitap kitap) async{
    Database? db = await _veriTabaniniGetir();

    if(db != null){
      return await db.delete(
        _kitaplarTabloAdi,
        where: "$_idKitaplar = ?",
        whereArgs: [kitap.id],
      );
    }
    else{
      return 0;
    }
  }

  @override
  Future<int> deleteSeciliKitaplar(List seciliKitapIdleri) async{
    Database? db = await _veriTabaniniGetir();

    if(db != null && seciliKitapIdleri.isNotEmpty){

      String filtre = "$_idKitaplar in (";

      for(int i=0; i<seciliKitapIdleri.length;i++){
        if(i != seciliKitapIdleri.length-1){
          filtre += "?,";
        }
        else{
          filtre += "?)";
        }
      }

      return await db.delete(
        _kitaplarTabloAdi,
        where: filtre,
        whereArgs: seciliKitapIdleri,
      );
    }
    else{
      return 0;
    }
  }

  @override
  Future createBolum(Bolum bolum) async{
    Database? db = await _veriTabaniniGetir();

    if(db != null){
      return await  db.insert(_bolumlerTabloAdi,bolum.toMap());
    }
    else{
      return -1;
    }
  }

  @override
  Future<List<Bolum>> readTumBolumler(kitapId) async{
    Database? db = await _veriTabaniniGetir();
    List<Bolum> bolumler = [];

    if(db != null){
      List<Map<String,dynamic>> bolumlerMap = await
      db.query(_bolumlerTabloAdi,
          where: "$_kitapIdBolumler = ?",
          whereArgs: [kitapId]
      );
      for(var eleman in bolumlerMap){
        Bolum b= Bolum.fromMap(eleman);
        bolumler.add(b);
      }
    }
    return bolumler;
  }

  @override
  Future<int> updateBolum(Bolum bolum) async{
    Database? db = await _veriTabaniniGetir();

    if(db != null){
      return await db.update(
          _bolumlerTabloAdi,
          bolum.toMap(),
          where: "$_idBolumler = ?",
          whereArgs: [bolum.id]
      );
    }
    else{
      return 0;
    }
  }

  @override
  Future<int> deleteBolum(Bolum bolum) async{
    Database? db = await _veriTabaniniGetir();

    if(db != null){
      return await db.delete(
          _bolumlerTabloAdi,
          where: "$_idBolumler = ?",
          whereArgs: [bolum.id]
      );
    }
    else{
      return 0;
    }
  }


}