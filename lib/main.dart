import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=b0b4ecc3";

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      ),
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double euro;
    double dolar;
    double bitcoin;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(
            "Exchange App",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.black,
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text("Carregando Dados...",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0,
                        ),
                        textAlign: TextAlign.center),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro ao Carregar Dados...",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0,
                          ),
                          textAlign: TextAlign.center),
                    );
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                            child: Icon(Icons.monetization_on,
                                size: 100.0, color: Colors.amber),
                          ),
                          currencyTextField("Real", "R\$"),
                          Divider(),
                          currencyTextField("Dólar", "US\$"),
                          Divider(),
                          currencyTextField("Euro", "€")
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget currencyTextField(String label, String symbol) {
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
      border: OutlineInputBorder(),
      prefixText: symbol,
      prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
  );
}
