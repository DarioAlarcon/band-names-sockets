import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum serverStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{
  serverStatus _serverStatus = serverStatus.Connecting;
  late IO.Socket _socket;

  serverStatus get ServerStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  
  SocketService(){
    this._initConfig();
  }

  void _initConfig(){

    this._socket = IO.io('http://localhost:3000/',{
      'transports': ['websocket'],
      'autoConnect': true
    });


  this._socket.onConnect((_) {
    this._serverStatus = serverStatus.Online;
    notifyListeners();
  });
  this._socket.on('disconnect',(_) {
    this._serverStatus = serverStatus.Offline;
    notifyListeners();
  });
  
  }

}