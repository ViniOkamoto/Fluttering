import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lista_contatos/helpers/contact_helper.dart';
import 'package:lista_contatos/models/contact.dart';
import 'file:///C:/Users/vinicius.goncalves/Coding/Flutterando/lista_contatos/lib/screens/contact/contact_page.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contactsList = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contatos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child:Text("Ordernar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child:Text("Ordernar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
      body: _buildListView(),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contactsList.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }
      );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onDoubleTap: (){
        _showCallDialog(context, contactsList[index]);
      },
      child: Dismissible(
        key: Key(contactsList[index].id.toString()),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            _showContactPage(contact: contactsList[index]);
            return false;
          } else {
            return _showDeleteDialog(context, contactsList[index]);
          }
        },
        background: Card(
          child: Container(
              padding: EdgeInsets.only(left: 20),
              color: Colors.deepOrange,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.create,
                  color: Colors.white,
                  size: 30,
                ),
              )),
        ),
        secondaryBackground: Card(
          child: Container(
              padding: EdgeInsets.only(right: 20),
              color: Colors.redAccent,
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 30,
                ),
              )),
        ),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: contactsList[index].img != null
                            ? FileImage(File(contactsList[index].img))
                            : AssetImage("images/person.png"),
                          fit: BoxFit.cover
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(contactsList[index].name ?? "",
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent)),
                      Text(contactsList[index].email ?? "",
                          style: TextStyle(
                              fontSize: 18, color: Colors.deepOrangeAccent)),
                      Text(contactsList[index].phone ?? "",
                          style: TextStyle(
                              fontSize: 18, color: Colors.deepOrangeAccent))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
        _getAllContacts();
    }
  }

  bool _showDeleteDialog(BuildContext context, Contact contact)  {
    bool callback;

    Widget cancelButton = FlatButton(
      child: Text("Cancelar", style: TextStyle(color: Colors.white),),
      onPressed: () {
        callback = false;
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continar",style: TextStyle(color: Colors.white),),
      onPressed: () {
        callback = true;
        helper.deleteContact(contact.id);
        _getAllContacts();
        Navigator.of(context).pop();
      },
    );
    //configure o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deletar o usuário"),
      titleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: Colors.black,
      content: Text("Deseja deletar o ${contact.name} dos seus contatos ?"),
      contentTextStyle: TextStyle(color: Colors.deepOrange),
      shape:  new RoundedRectangleBorder(
          side: BorderSide(color: Colors.deepOrange, width: 1),
          borderRadius: new BorderRadius.all(Radius.circular(0))
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return callback;
  }
   void _showCallDialog(BuildContext context, Contact contact)  {
    Widget cancelButton = FlatButton(
      child: Text("Cancelar", style: TextStyle(color: Colors.white),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continar", style: TextStyle(color: Colors.white),),
      onPressed: () {
        launch("tel:${contact.phone}");
        Navigator.of(context).pop();
      },
    );
    //configure o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Ligar"),
      titleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: Colors.black,
      content: Text("Deseja ligar para o ${contact.name}?"),
      contentTextStyle: TextStyle(color: Colors.deepOrange),
      shape: new RoundedRectangleBorder(
        side: BorderSide(color: Colors.deepOrange, width: 1),
        borderRadius: new BorderRadius.all(Radius.circular(0))
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _getAllContacts() {
    helper.getAllContact().then((list) {
      setState(() {
        contactsList = list;
      });
    });
  }
  void _orderList(OrderOptions result){
    setState(() {
      switch(result){
        case OrderOptions.orderaz:
          contactsList.sort((a,b){
           return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
          break;
        case OrderOptions.orderza:
        contactsList.sort((a,b){
         return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
      }
    });
  }
}
