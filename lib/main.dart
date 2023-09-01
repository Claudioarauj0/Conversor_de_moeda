import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=2d0d692b";

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.black,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

Future<Map> getData() async {
  Uri uri = Uri.parse(request); // Criar um objeto Uri a partir da string
  http.Response response = await http.get(uri);
  return jsonDecode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  late double dolar;
  late double euro;

  void clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void realChanged(String text) {
    if (text.isEmpty) {
      clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void dolarChanged(String text) {
    if (text.isEmpty) {
      clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void euroChanged(String text) {
    if (text.isEmpty) {
      clearAll();
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
        title: const Text("\$ Conversor \$",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao carregar os dados",
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                // Aqui você pode acessar os dados usando snapshot.data
                // Por exemplo: var currencyData = snapshot.data;
                dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    const Icon(
                      Icons.monetization_on_outlined,
                      size: 120,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: campodevalor(
                          "Reais", "R\$", realController, realChanged),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: campodevalor(
                          "Dolar", "US\$", dolarController, dolarChanged),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: campodevalor(
                          "Euro", "€", euroController, euroChanged),
                    ),
                  ],
                ));
              }
          }
        },
      ),
    );
  }
}

Widget campodevalor(String label, String prefix, TextEditingController c,
        Function(String) f) =>
    TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
      ),
      onChanged: f,
      keyboardType: const TextInputType.numberWithOptions(),
    );
