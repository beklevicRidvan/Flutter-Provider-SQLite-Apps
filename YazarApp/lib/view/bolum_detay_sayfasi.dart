import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_yaxar_projesi/view_model/bolum_detay_view_model.dart';


class BolumDetay extends StatelessWidget {

  BolumDetay({super.key,});


  TextEditingController  _icerikController =  TextEditingController();



  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    BolumDetayViewModel viewModel = Provider.of<BolumDetayViewModel>(context,listen: false);
    return AppBar(
      title: (Text(viewModel.bolum.baslik)),
      actions: [
        IconButton(onPressed: (){
          viewModel.icerigiKaydet(_icerikController.text);
        }, icon: const Icon(Icons.save))
      ],
    );
  }


  Widget _buildBody(BuildContext context) {
    BolumDetayViewModel viewModel = Provider.of<BolumDetayViewModel>(context,listen: false);

    _icerikController.text = viewModel.bolum.icerik;


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _icerikController,
        textInputAction: TextInputAction.done,
        maxLines: 1000,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
          )
        ),
      ),
    );
  }



}
