import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_yaxar_projesi/repository/database_repository.dart';
import 'package:sqlite_yaxar_projesi/tools/locator.dart';
import 'package:sqlite_yaxar_projesi/view_model/bolumler_view_model.dart';
import '../tools/sabitler.dart';
import '../model/kitap_model.dart';
import '../view/bolumler_sayfasi.dart';

class KitaplarViewModel with ChangeNotifier{


  final DatabaseRepository _databaseRepository = locator<DatabaseRepository>();




  List<Kitap> _kitaplar = [];
  List<int> seciliKitapIdleri = [];

  List<int> tumKategoriler = [-1];
  int _secilenKategori = -1;

  final ScrollController _scrollController = ScrollController();


  ScrollController get scrollController => _scrollController;


  List<Kitap> get kitaplar => _kitaplar;



  KitaplarViewModel(){
    tumKategoriler.addAll(Sabitler.kategoriler.keys);
    _scrollController.addListener(() => _kaydirmaKontrol());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ilkKitaplariGetir();
    });
  }

  Future<void> ilkKitaplariGetir() async {
    if(_kitaplar.isEmpty){
      _kitaplar = await _databaseRepository.readTumKitaplar(_secilenKategori,0);
      notifyListeners();

    }

  }


  Future<void> sonrakiKitaplariGetir() async{
    int? sonKitapId = _kitaplar.last.id;
    if(sonKitapId != null){
      List<Kitap> sonrakiKitaplar = await _databaseRepository.readTumKitaplar(_secilenKategori, sonKitapId);
      _kitaplar.addAll(sonrakiKitaplar);
      notifyListeners();
    }


  }



  void kitapEkle(BuildContext context) async {

    List<dynamic>? sonuc = await _pencereAc(context);

    if (sonuc != null && sonuc.length > 1) {
      String kitapAdi = sonuc[0];
      int kategori = sonuc[1];
      Kitap yeniKitap = Kitap(kitapAdi, DateTime.now(), kategori);
      int kitapIdsi = await _databaseRepository.createKitap(yeniKitap);
      debugPrint("Kitap ID: $kitapIdsi");
      yeniKitap.id = kitapIdsi;
      _kitaplar.add(yeniKitap);
      notifyListeners();
      //setState(() {});
    }





  }


  void kitapSil(int index) async {
    Kitap kitap = _kitaplar[index];

    int silinenSatirSayisi = await _databaseRepository.deleteKitap(kitap);

    if (silinenSatirSayisi > 0) {
      _kitaplar.removeAt(index);
      notifyListeners();
    }
  }

  void secilenKitaplariSil() async {
    int silinenSatirSayisi =
    await _databaseRepository.deleteSeciliKitaplar(seciliKitapIdleri);

    if (silinenSatirSayisi > 0) {
      _kitaplar.removeWhere((kitap) => seciliKitapIdleri.contains(kitap.id));
      notifyListeners();
    }
  }

  void kitapGuncelle(BuildContext context, int index) async {
    Kitap kitap = _kitaplar[index];

    List<dynamic>? sonuc = await _pencereAc(
      context,
      mevcutIsim: kitap.isim,
      mevcutKategori: kitap.kategori,
    );

    if (sonuc != null && sonuc.length > 1) {
      String yeniKitapAdi = sonuc[0];
      int yeniKategori = sonuc[1];

      if (kitap.isim != yeniKitapAdi || kitap.kategori != yeniKategori) {
        kitap.guncelle(yeniKitapAdi, yeniKategori);

        int guncellenenSatirSayisi = await _databaseRepository.updateKitap(kitap);
        if (guncellenenSatirSayisi > 0) {

        }
      }
    }
  }

  Future<List<dynamic>?> _pencereAc(
      BuildContext context,{String mevcutIsim = "", int mevcutKategori = 0}) {
    TextEditingController isimController =
    TextEditingController(text: mevcutIsim);
    int? kategori = mevcutKategori;

    return showDialog<List<dynamic>>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Kitap Adını Giriniz"),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: isimController,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Kategori:"),
                        DropdownButton(
                            value: kategori,
                            items: Sabitler.kategoriler.keys.map((kategoriId) {
                              return DropdownMenuItem<int>(
                                  value: kategoriId,
                                  child: Text(
                                      Sabitler.kategoriler[kategoriId] ?? ""));
                            }).toList(),
                            onChanged: (int? deger) {
                              if (deger != null) {
                                setState(() {
                                  kategori = deger;
                                });
                              }
                            })
                      ],
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("İptal")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(
                        context, [isimController.text.trim(), kategori]);
                    //setState(() {});
                  },
                  child: const Text("Onayla")),
            ],
          );
        });
  }




  void bolumlerSayfasiniAc(BuildContext context, int index) {
    MaterialPageRoute sayfaYolu = MaterialPageRoute(builder: (context) {
      return ChangeNotifierProvider(
        create: (context)=>BolumlerViewModel(_kitaplar[index]),
        child: const BolumlerSayfasi(),);
    });
    Navigator.push(context, sayfaYolu);
  }

  _kaydirmaKontrol() {
    if(_scrollController.offset == _scrollController.position.maxScrollExtent){
      sonrakiKitaplariGetir();
    }
  }

  int get secilenKategori => _secilenKategori;

  set secilenKategori(int value) {
    _secilenKategori = value;
    notifyListeners();
  }

  set kitaplar(List<Kitap> value) {
    _kitaplar = value;
  }
}