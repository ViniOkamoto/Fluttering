import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


const request = "https://api.hgbrasil.com/finance?key=60f4fd90";
void main() async
{
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getData() async
{
  http.Response response = await http.get((request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dollarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double eurp = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro/dollar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
  }
  double dollar;
  double euro;
  var label = "Reais";
  var prefix = "R\$";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor"),
      backgroundColor: Colors.amber,
        centerTitle: true,
    ),
      body: FutureBuilder<Map>(
        future: getData(),
        // ignore: missing_return
        builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
          dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
          euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
          return SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
            Divider(),
          buildTextField("Reais", "R\$ ", realController, _realChanged),
              Divider(),
            buildTextField("Dollar", "\$ ", dollarController, _dollarChanged),
              Divider(),
            buildTextField("Euro", "€ ", euroController, _euroChanged),

          ],
          ),
          );
          case ConnectionState.active:
            return Container(
                child: Center(
                  child: Text(
                    "Dados 2",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  ),
                ));
          default:
            if(snapshot.hasError){
              return Center(
                  child: Text("Erro ao carregar dados :(",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0
                    ),
                    textAlign: TextAlign.center,)

              );
            } else {
              return Center(
                  child: Text("Carregando Dados...",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0
                    ),
                    // ignore: missing_return
                    textAlign: TextAlign.center,)

              );
            }
        }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function text){
 return TextField(
      controller: controller,
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.amber,
              fontSize: 25.0),
          border: OutlineInputBorder(),
          prefixText: prefix,
          prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0),//colocar essa pra prefixtext
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ), //colocar essa pra borda mudar cor na seleção
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber,)
          ) //colocar essa pra borda ficar OURO antes da seleção
      ),
    onChanged: text,
   keyboardType: TextInputType.numberWithOptions(decimal: true),
 );
}