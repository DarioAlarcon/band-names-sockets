import 'dart:ffi';
import 'dart:io';

import 'package:band_new_app/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
//import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_services.dart';
class Homepage extends StatefulWidget {
 
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<Band> bands = [
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic data){
      this.bands = (data as List)
      .map((band) => Band.fromMap(band) )
      .toList();
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Center(child: Text('BandNames', style: TextStyle(color: Colors.black))),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: 
            (socketService.ServerStatus == serverStatus.Online)?Icon(Icons.wifi, color: Colors.green,):Icon(Icons.wifi_off_outlined, color: Colors.red,),
            //
            //
          ),
        ],
      ),
      body: Column(
        children: [
          _showGraphic(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length, 
              itemBuilder: ( context,  index) => _bandTile(bands[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: Icon(Icons.add),
        elevation: 1,
        backgroundColor: Colors.redAccent[200],
      ),
    );
  }
  
  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);


    return Dismissible(
      key: Key(band.id),
      onDismissed: (direction) {
        socketService.socket.emit('delete-band',{'id': band.id});
      },
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20,),
            Icon(
              Icons.delete,
              color: Colors.white,
              ),
          ],
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: ListTile(
        onTap: () {
          socketService.socket.emit('vote-band', {'id': band.id});
        },
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.redAccent[100],
        ),
        title: Text(band.name, style: TextStyle(fontWeight: FontWeight.w400),),
        trailing: Text('${ band.votes }', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    );
  }

  addNewBand(){

    final textcontoller = new TextEditingController();

    if (!Platform.isIOS) {
      showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text('New band name'),
          content: TextField(
            controller: textcontoller,
            cursorColor: Colors.redAccent,
            decoration: InputDecoration(
              labelText: 'enter new band',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Cambia el color aquí
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => addBandToList(textcontoller.text),
              child: Text('Add'),
              elevation: 5,
              textColor: Colors.redAccent,
            )
          ],
        );
      },
    );
    }else{
      showCupertinoDialog(
      context: context, 
      builder: ( _ ){
        return CupertinoAlertDialog(
          title: Text('New Band Name'),
          content: CupertinoTextField(
            controller: textcontoller,
            cursorColor: Colors.redAccent,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              textStyle: TextStyle(color: Colors.green),
              child: Text('add'),
              onPressed: () => addBandToList(textcontoller.text),
              ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('close'),
              onPressed: () => Navigator.pop(context),
              )
          ],
        );
      }
      );
    }

    
  }

  void addBandToList(String name){
    if(name.length > 1){
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band-to-list',{'nombre': name});
    }
    Navigator.pop(context);
  }

Widget _showGraphic(){
   Map<String, double> dataMap =  {};
  //dataMap.putIfAbsent('', ()=>0);
  void llenarGrafica(Band b){
    dataMap.putIfAbsent(b.name, ()=>b.votes.toDouble());
  }

  bands.forEach(llenarGrafica);
List<Color> colores=
[
 //Colors.transparent,
 Colors.purpleAccent,
 Colors.lightBlueAccent,
 Colors.deepOrangeAccent,
 Colors.deepPurpleAccent,
 Colors.tealAccent,
 Colors.cyanAccent,
 Colors.indigoAccent,
 Colors.indigo
];

if (dataMap.isEmpty) {
  Map<String, double> dataMapAux =  {
    'insert new band':0
  };
  List<Color> coloresAux=[Colors.blueGrey];
  return Container(
    padding: EdgeInsets.all(5),
    width: double.infinity,
    height: 200,
    child: PieChart(
      emptyColor: Colors.black38,
      colorList: coloresAux,
      chartType: ChartType.ring,
      dataMap: dataMapAux)
  );
} else{
  return Container(
    padding: EdgeInsets.all(5),
    width: double.infinity,
    height: 200,
    child: PieChart(
      emptyColor: Colors.black38,
      colorList: colores,
      chartType: ChartType.ring,
      dataMap: dataMap)
      );
}

}

}