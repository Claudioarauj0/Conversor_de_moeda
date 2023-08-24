import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversor", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              Icons.monetization_on_outlined,
              size: 120,
              color: Colors.black,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Reais",
                  labelStyle: TextStyle(color: Colors.black)),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Dolar",
                  labelStyle: TextStyle(color: Colors.black)),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Euro",
                  labelStyle: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
      )
    );    
  }
}
