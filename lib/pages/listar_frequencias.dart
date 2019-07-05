import 'dart:async';
import 'package:drawer/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListarFrequencias extends StatefulWidget{
  final Usuario usuario;

  const ListarFrequencias({Key key, this.usuario}): super(key: key);  
  @override
  ListarFrequenciasPage createState() => ListarFrequenciasPage(usuario: this.usuario);
}

class ListarFrequenciasPage extends State<ListarFrequencias>{
  Usuario usuario;
  var responseJSON, matriculaResult, senhaResult;
  String hora, dataFreq, tipoFreq, usuarioFreq, atividade;
  String responseBody;
  ListarFrequenciasPage({this.usuario});
  List data;
  var url = "http://192.168.1.3:9000/frequencias/listarFreqApp";

  Future<String> getData() async{
    var response = await http.post(url,  body: {'matricula': usuario.matricula});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');      
    responseBody = response.body;    
    this.setState((){
      data = json.decode(responseBody);
    });
  }

  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Lista de Frequências"),
        backgroundColor: Colors.black87,
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new Card(
            child:  new  Text(data[index]["tipoFreq"]),
          );
        }
      ),
    );
    return null;
  }
}