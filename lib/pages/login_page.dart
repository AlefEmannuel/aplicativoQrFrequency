import 'package:flutter/material.dart';
import './home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../classes/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // f45d27
  // f5851f
  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  var matriculaResult;
  var senhaResult;
  var url = "http://192.168.1.9:9000/logins/autenticarSuapApp";
  //String nome,matricula,tipoVinculo,url_foto_75x100,email;
  String responseBody;
  String validador = "0";
  var responseJSON;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF000000),
                    Color(0xFF000000)
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.person,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),

                  Align(
                    alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 32,
                          right: 32
                        ),
                        child: Text('Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 62),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
                    padding: EdgeInsets.only(
                      top: 4,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5
                        )
                      ]
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.perm_identity,
                            color: Colors.grey,
                        ),
                          hintText: 'Matricula',
                      ),
                      onChanged: (String matricula){
                        setState(() {
                          matriculaResult = matricula;
                          print(matriculaResult);
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.only(
                        top: 4,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(50)
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5
                          )
                        ]
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        hintText: 'Senha',
                      ),
                      onChanged: (String senha){
                        setState(() {
                          senhaResult = senha;
                          print(matriculaResult);
                        });
                      },
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16, right: 32
                      ),
                      child: Text('Esqueceu sua senha?',
                        style: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  new GestureDetector(
                    onTap: () async {      
                      var response = await http.post(url,  body: {'matricula': matriculaResult, 'senha': senhaResult});
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');      
                      responseBody = response.body;
                      responseJSON = json.decode(responseBody);                       
                      if(responseBody.length > 1){
                        Usuario usuario = new Usuario(responseJSON['nome'], responseJSON['matricula'], responseJSON['tipoVinculo'], responseJSON['url_foto_75x100'], responseJSON['email']);   
                        print(usuario.getTipoVinculo);
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new HomePage(usuario: usuario)));
                      }else{
                        _ackAlert(context);
                      }
                    },
                  child: new Container(                    
                    height: 45,
                    width: MediaQuery.of(context).size.width/1.2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF000000),
                          Color(0xFF000000)
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50)
                      )
                    ),
                    child: Center(
                      child: Text('Login'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

Future solicitarLogin() async {
    var response = await http.post(url,  body: {'matricula': matriculaResult, 'senha': senhaResult});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');      
    responseBody = response.body;
    responseJSON = json.decode(responseBody);
    /*if(responseJSON != 0){     
      nome = responseJSON['nome'];
      matricula = responseJSON['matricula'];
      tipoVinculo = responseJSON['tipoVinculo'];
      url_foto_75x100 = responseJSON['url_foto_75x100'];
      email = responseJSON['email'];
      Usuario usuario = new Usuario(nome, matricula, tipoVinculo, url_foto_75x100, email); 
      print(usuario.getNome);
      print(usuario.email);
      print(usuario.matricula);
      return 1;
    }else{
      responseJSON = 0;
      return 0;
    }*/
}

Future<void> _ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Dados incorretos'),
        content: const Text('Seus dados inseridos estão incorretos.'),
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