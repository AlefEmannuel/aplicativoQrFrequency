import 'dart:convert';

class Frequencia {
  final String hora;
  final String data;
  final String tipoFreq;
  final String atividade; 

  Frequencia(
    this.hora,
    this.data,
    this.tipoFreq,
    this.atividade,
  );

  String get getNome => hora;
  String get getMatricula => data;
  String get getTipoVinculo => tipoFreq;
  String get getFoto => atividade;
}
