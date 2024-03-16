import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_yaxar_projesi/tools/sabitler.dart';
import 'package:sqlite_yaxar_projesi/view_model/kitaplar_view_model.dart';

import '../model/kitap_model.dart';

class KitaplarSayfasi extends StatelessWidget {
  const KitaplarSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: _buildKitapEkle(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    KitaplarViewModel viewModel =
        Provider.of<KitaplarViewModel>(context, listen: false);
    return AppBar(
      title: const Text("Kitaplar Sayfası"),
      actions: [
        IconButton(
            onPressed: () {
              viewModel.secilenKitaplariSil();
            },
            icon: const Icon(Icons.delete))
      ],
    );
  }

  Widget _buildKitapEkle(BuildContext context) {
    KitaplarViewModel viewModel = Provider.of(context,listen: false);
    return FloatingActionButton(
      onPressed: () {
        viewModel.kitapEkle(context);
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildKategoriFiltresi(),
        Expanded(
          child: Consumer<KitaplarViewModel>(
            builder: (context, viewModel, child) => ListView.builder(
              controller: viewModel.scrollController,
              itemBuilder: (context,index){
                return ChangeNotifierProvider.value(value: viewModel.kitaplar[index],child: _buildListItem(context,index),);
              },
              itemCount: viewModel.kitaplar.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context,int index) {
    KitaplarViewModel viewModel = Provider.of(context,listen: false);
    return Consumer<Kitap>(builder: (context,kitap,child){
      return ListTile(
        title: Text(kitap.isim),
        subtitle: Text(Sabitler.kategoriler[kitap.kategori] ?? ""),
        leading: CircleAvatar(
          child: Text(kitap.id.toString()),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  viewModel.kitapGuncelle(context, index);
                },
                icon: const Icon(Icons.edit)),
            Checkbox(
                value: kitap.seciliMi,
                onChanged: (bool? yeniDeger) {
                  if (yeniDeger != null) {
                    int? kitapId = kitap.id;

                    if (kitapId != null) {

                        if (yeniDeger) {
                          viewModel.seciliKitapIdleri.add(kitapId);
                        } else {
                          viewModel.seciliKitapIdleri.remove(kitapId);
                        }
                        kitap.sec(yeniDeger);

                    }
                  }
                })
          ],
        ),

        onTap: () {
          viewModel.bolumlerSayfasiniAc(context, index);
        },
      );
    });
  }

  Widget _buildKategoriFiltresi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("Kategori:"),
        Consumer<KitaplarViewModel>(
          builder: (context, viewModel, child) => DropdownButton(
              value: viewModel.secilenKategori,
              items: viewModel.tumKategoriler.map((kategoriId) {
                return DropdownMenuItem<int>(
                    value: kategoriId,
                    child: Text(kategoriId == -1
                        ? "Hepsi"
                        : Sabitler.kategoriler[kategoriId] ?? ""));
              }).toList(),
              onChanged: (int? deger) {
                if (deger != null) {

                    viewModel.secilenKategori = deger;
                    viewModel.kitaplar = []; // Kategori değiştiğinde kitapları sıfırla
                    viewModel.ilkKitaplariGetir(); // Yeniden kitapları getir

                }
              }),
        )
      ],
    );
  }
}
