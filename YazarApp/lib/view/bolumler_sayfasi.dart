import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_yaxar_projesi/view_model/bolumler_view_model.dart';

import '../model/bolum_model.dart';


class BolumlerSayfasi extends StatelessWidget {

  const BolumlerSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: _buildBolumEkle(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context){
    BolumlerViewModel viewModel = Provider.of<BolumlerViewModel>(context,listen: false);
    return AppBar(
      title: Text(viewModel.kitap.isim),
    );
  }

  Widget _buildBolumEkle(BuildContext context){
    BolumlerViewModel viewModel = Provider.of<BolumlerViewModel>(context,listen: false);
    return FloatingActionButton(
      onPressed:(){
        viewModel.bolumEkle(context);
      },
      child: const Icon(Icons.add),
    );
  }



  Widget _buildBody(){
    return Consumer<BolumlerViewModel>(builder: (context,viewModel,child){
      return ListView.builder(
      itemBuilder: (BuildContext context, int index){
        return ChangeNotifierProvider.value(
          value: viewModel.bolumler[index],
          child: _buildListItem(context, index),
        );
      },
      itemCount: viewModel.bolumler.length,);
    });
  }

  Widget _buildListItem(BuildContext context, int index) {

    BolumlerViewModel viewModel = Provider.of<BolumlerViewModel>(context,listen: false);

   return Consumer<Bolum>(builder: (context,bolum,child){
     return ListTile(
       title: Text(bolum.baslik),
       leading: CircleAvatar(child: Text(bolum.id.toString()),),
       trailing: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           IconButton(onPressed: (){
             viewModel.bolumGuncelle(context,index);
           }, icon: const Icon(Icons.edit)),
           IconButton(onPressed: (){
             viewModel.bolumSil(index);
           }, icon: const Icon(Icons.delete)),
         ],
       ),
       onTap:  (){

         viewModel.bolumlerDetaySayfasiniAc(context,index);

       },



     );
   });
  }
}
