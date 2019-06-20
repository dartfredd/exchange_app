import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=b0b4ecc3";

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner:false,
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
  double euro;
  double dolar;
  double bitcoin;

  final realController = TextEditingController();
  final euroController = TextEditingController();
  final dolarController = TextEditingController();

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      this._clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      this._clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      this._clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
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
                    bitcoin =  snapshot.data["results"]["currencies"]["BTC"]["buy"];
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
                          currencyTextField(
                              "Real", "R\$", realController, _realChanged),
                          Divider(),
                          currencyTextField(
                              "Dólar", "US\$", dolarController, _dolarChanged),
                          Divider(),
                          currencyTextField(
                              "Euro", "€", euroController, _euroChanged),
                          Divider(),
                          Row(
                            children: <Widget>[
                            expandedWithExchange("DOLAR", dolar , "\$"),
                            expandedWithExchange("EURO", euro , "€"),
                            ],
                          ),Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            
                            children: <Widget>[
                            Icon(Icons.monetization_on , color: Colors.amber , size: 25.0 ),
                            Text("BITCOIN", style: TextStyle(color:Colors.amber , fontSize: 25.0),)
                          ],),Divider(),
                          Text("R\$" + bitcoin.toStringAsFixed(2) , style:TextStyle(color:Colors.amber , fontSize: 25.0), textAlign: TextAlign.center)
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget currencyTextField(String label, String symbol,
    TextEditingController controller, Function change) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
      border: OutlineInputBorder(),
      prefixText: symbol,
      prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: change,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}

Widget expandedWithExchange(String label , double value , String prefix) {
  return Expanded(
      child: Column(
    children: <Widget>[
      Text(
        label,
        style: TextStyle(color: Colors.amber),
        textAlign: TextAlign.center,
      ),
      Text(
        prefix + value.toStringAsFixed(2),
        style: TextStyle(color: Colors.amber),
        textAlign: TextAlign.center,
      )
    ],
  ));
}
