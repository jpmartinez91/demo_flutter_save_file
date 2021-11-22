import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _storage = const FlutterSecureStorage();
  List<String> _exPath = [];

  @override
  void initState() {
    super.initState();


    getPublicDirectoryPath();
  }

  String _randomValue() {
    final rand = Random();
    final codeUnits = List.generate(20, (index) {
      return rand.nextInt(26) + 65;
    });

    return String.fromCharCodes(codeUnits);
  }
  // To get public storage directory path like Downloads, Picture, Movie etc.
  // Use below code
  Future<void> getPublicDirectoryPath() async {

    //+++ validaciones
    //1. verificar si archivo y claves de secure existen
    // 1.1 comprobar contenido de ambas banderas (archivo y secure storage)
    //2. crear elemento faltantes
    // continuar con el flujo de login
    final String key = 'test';
    final String value = _randomValue();
    await _storage.write(
        key: key,
        value: value);
    final all = await _storage.read(key: key);
    print(all);
    //+++ se debe almacenar el contenido de la key value antes generado dentro del archivo a guardar
    //++ opcional se puede implmentar plugin external_path
    //+++ se debe solicitar permisos en tiempo de ejecucion...!!
    String path = '/storage/emulated/0/MyFile/test.txt' ;
    new File(path).create(recursive: true)
        .then((File file) {
      print('${file.path}');
    });
    setState(() {
      _exPath.add(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ListView.builder(
              itemCount: _exPath.length,
              itemBuilder: (context, index) {
                return Center(child: Text("${_exPath[index]}"));
              }),
        ));
  }
}
