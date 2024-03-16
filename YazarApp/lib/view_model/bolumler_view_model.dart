
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_yaxar_projesi/view_model/bolum_detay_view_model.dart';

import '../model/bolum_model.dart';
import '../model/kitap_model.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';
import '../view/bolum_detay_sayfasi.dart';

class BolumlerViewModel with ChangeNotifier{

  final DatabaseRepository _databaseRepository = locator<DatabaseRepository>();




  List<Bolum> _bolumler = [];

  final Kitap _kitap;


  List<Bolum> get bolumler => _bolumler;

  BolumlerViewModel(this._kitap){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tumBolumlariGetir();
    });
  }


  void bolumEkle(BuildContext context) async{
    String? bolumBasligi = await pencereAc(context);
    int? kitapId =_kitap.id;
    if(bolumBasligi != null && kitapId != null){
      Bolum yeniBolum = Bolum(kitapId,bolumBasligi);
      int bolumIdsi = await _databaseRepository.createBolum(yeniBolum);
      debugPrint("Bolum ID: $bolumIdsi");
      yeniBolum.id = bolumIdsi;
      bolumler.add(yeniBolum);
      notifyListeners();

    }
  }

  void bolumSil(int index) async{
    Bolum bolum = _bolumler[index];

    int silinenSatirSayisi = await _databaseRepository.deleteBolum(bolum);

    if(silinenSatirSayisi > 0 ){
      _bolumler.removeAt(index);
      notifyListeners();
    }
  }

  void bolumGuncelle(BuildContext context,int index) async{
    String? yeniBolumBasligi = await pencereAc(context);

    if(yeniBolumBasligi != null){
      Bolum bolum = _bolumler[index];
      bolum.guncelle(yeniBolumBasligi);

      int guncellenenSatirSayisi = await _databaseRepository.updateBolum(bolum);
      if(guncellenenSatirSayisi>0){
      }
    }
  }

  Future<String?> pencereAc(BuildContext context) {
    String? sonuc;

    return  showDialog<String>(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Bolum Adını Giriniz"),
        content: TextField(
          onChanged: (yeniDeger){
            sonuc = yeniDeger;
          },

        ),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("İptal")),
          TextButton(onPressed: (){
            Navigator.pop(context,sonuc);
           // setState(() {});
          }, child: const Text("Onayla")),

        ],
      );
    });
  }

  Future<void> tumBolumlariGetir() async{
    int? kitapId = _kitap.id;

    if(kitapId != null){
      _bolumler = await _databaseRepository.readTumBolumler(kitapId);
      notifyListeners();

    }

  }

  void bolumlerDetaySayfasiniAc(BuildContext context,int index){
    MaterialPageRoute sayfaYolu = MaterialPageRoute(builder: (context){
      return ChangeNotifierProvider(
        create:(context)=> BolumDetayViewModel(_bolumler[index]),
        child:  BolumDetay(),
      );
    });
    Navigator.push(context, sayfaYolu);
  }

  Kitap get kitap => _kitap;
}