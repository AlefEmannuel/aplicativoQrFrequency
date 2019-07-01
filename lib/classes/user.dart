import 'dart:convert';

class Usuario {
  final String nome;
  final String matricula;
  final String tipoVinculo;
  final String url_foto_75x100;
  final String email;

  Usuario(
    this.nome,
    this.matricula,
    this.tipoVinculo,
    this.url_foto_75x100,
    this.email,
  );

  String get getNome => nome;
  String get getMatricula => matricula;
  String get getTipoVinculo => tipoVinculo;
  String get getFoto => url_foto_75x100;
  String get getEmail => email;

}
