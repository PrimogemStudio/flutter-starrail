import 'dart:convert';
import 'dart:io';

Socket? socket;
ServerSocket? serverSocket;

bool server = false;

void socketRecv(Function callback) {
  socket!.listen((data) => callback(JsonDecoder().convert(utf8.decode(data))));
}

void socketSend(dynamic json) async {
  socket!.write(JsonEncoder().convert(json));
  await socket!.flush();
}