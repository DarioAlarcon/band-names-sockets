import 'dart:ffi';
import 'dart:io';

import 'package:band_new_app/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Homepage extends StatefulWidget {
 
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<Band> bands = [
    Band(id: '1', name:'Bad Bunny', votes: 5),
    Band(id: '2', name:'Anuel', votes: 1),
    Band(id: '3', name:'Morat', votes: 3),
    Band(id: '4', name:'Los Diablitos', votes: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Center(child: Text('BandNames', style: TextStyle(color: Colors.black))),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length, 
        itemBuilder: ( context,  index) => _bandTile(bands[index]),
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
    return Dismissible(
      key: Key(band.id),
      onDismissed: (direction) {
        print('direction: $direction');
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
      print(name);
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 6));
      setState(() {});
    }
    Navigator.pop(context);
  }

}