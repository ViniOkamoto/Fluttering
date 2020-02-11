import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados!";
  void _resetFields(){
    weightController.text = "";
    heightController.text = "";
    setState(() {
    _infoText = "Informe seus dados!";
    _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate(){
    setState(() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text)/100;
    double imc = weight /(height * height);
    if(imc < 18.6){
      _infoText = "Abaixo do Peso(${imc.toStringAsPrecision(4)})";
    } else if( imc >= 18.6 && imc < 24.9){
      _infoText = "Peso ideal(${imc.toStringAsPrecision(4)})";
    }else if( imc >= 24.9 && imc < 29.9){
      _infoText = "Levemente acima do peso(${imc.toStringAsPrecision(4)})";
    }else if( imc >= 29.9 && imc < 34.9){
      _infoText = "Obesidade grau I(${imc.toStringAsPrecision(4)})";
    }else if( imc >= 34.9 && imc < 39.9){
      _infoText = "Obesidade grau II(${imc.toStringAsPrecision(4)})";
    }else if( imc >= 40){
      _infoText = "Obesidade grau III(${imc.toStringAsPrecision(4)})";
    }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de imc"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.fitness_center,
                  size: 120.0, color: Colors.deepPurpleAccent),
              TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle:
                      TextStyle(color: Colors.deepPurple, fontSize: 25.0)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: weightController,
                  validator: (value){
                    if(value.isEmpty) {
                      return "Insira seu Peso";
                    }
                  }),
              TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Altura (cm)",
                      labelStyle:
                      TextStyle(color: Colors.deepPurple, fontSize: 25.0)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: heightController,
                  validator: (value) {
                    if(value.isEmpty){
                      return "Insira sua Altura";
                    }
                  }),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                      _calculate();
                      }
                    },
                    child: Text("Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0)),
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 25.0),
              )
            ],
          ),
        )
      ),
    );
  }
}
