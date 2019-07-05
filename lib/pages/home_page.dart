import 'package:flutter/material.dart';
import './cadastrar_frequencia.dart';
import './login_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../classes/user.dart';
import 'package:http/http.dart' as http;

import 'listar_frequencias.dart';


class HomePage extends StatefulWidget {
  final Usuario usuario;

  const HomePage({Key key, this.usuario}): super(key: key);  
  
  @override
  _HomePageState createState() => _HomePageState(usuario: this.usuario);
}

class _HomePageState extends State<HomePage> {
  Usuario usuario;
  _HomePageState({this.usuario});

  String barcode = "";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("QRFrequency"),backgroundColor: Colors.black87,),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(usuario.getNome),
              accountEmail: new Text(usuario.getEmail),
              currentAccountPicture: new GestureDetector(
                
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(usuario.getFoto),
                ),
              ),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage("https://quotefancy.com/media/wallpaper/3840x2160/871625-Alexis-Carrel-Quote-The-quality-of-life-is-more-important-than.jpg",),
                )
              ),
            ),
            new ListTile(
              title: new Text("Registrar Frequência"),
              trailing: new Icon(Icons.camera_alt),
              onTap: () => scan(usuario.matricula),
            ),
            new Divider(),
            new ListTile(
              title: new Text("Ver minhas frequências"),
              trailing: new Icon(Icons.reorder),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ListarFrequencias(usuario: usuario))),
            ),
            new Divider(),
            new ListTile(
              title: new Text("Sair"),
              trailing: new Icon(Icons.close),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage())),
            ),
          ],
        ),
      ),
      body: new Center(
        child: new Text("Home page", style: new TextStyle(fontSize: 35.0),),
      ),
    );
  }

Future scan(String matricula) async {
    var url = "http://192.168.1.3:9000/frequencias/salvarApp";
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      var response = await http.post(url,  body: {'idAtividade': barcode, 'matricula': matricula});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');      
      print(barcode);
      if(response.body == "true"){
        frequenciaCadastradaAlert(context);
      }else{
        frequenciaNaoCadastradaAlert(context);
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

Future<void> frequenciaCadastradaAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Frequência Cadastrada'),
        content: const Text('Sua frequência foi cadastrada com sucesso'),
        actions: <Widget>[
          FlatButton(
            child: Text('Entendi'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> frequenciaNaoCadastradaAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Frequência não cadastrada'),
        content: const Text('Não conseguimos cadastrar sua frequência, porfavor tente novamente.'),
        actions: <Widget>[
          FlatButton(
            child: Text('Entendi'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}