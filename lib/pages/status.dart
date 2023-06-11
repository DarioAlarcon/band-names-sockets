import 'package:band_new_app/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class statusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    //socketService.socket.emit(event)

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('ServerStatus: ${socketService.ServerStatus}')),
        ],
      ),
      floatingActionButton: FloatingActionButton
      ( child: Icon(Icons.add),
        elevation: 1,
        hoverColor: Colors.deepOrangeAccent,
        splashColor: Colors.orangeAccent,
        backgroundColor: Colors.redAccent,
        hoverElevation: 5,
        focusElevation: 0,
        highlightElevation: 10,
         onPressed: (){
          //emitir:
          //{nombre: 'flutter', mensaje: 'hola desde flutter'}
          socketService.socket.emit('nuevo-mensaje',{'nombre': 'flutter', 'mensaje': 'hola desde flutter'});
         },
      ),
    );
  }
}