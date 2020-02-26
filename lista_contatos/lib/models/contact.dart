final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class Contact{
  // id name email phone img
  int _id;
  String _name;
  String _email;
  String _phone;
  String _img;

  Contact();

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

   get id {
  return _id;
  }

  set id(value){
    _id = value;
  }
  String get name {
  return _name;
  }

  set name(value){
    _name = value;
  }


  String get email {
  return _email;
  }

  set email(value){
    _email = value;
  }
  String get phone {
  return _phone;
  }
  set phone(value){
    _phone = value;
  }
  String get img {
  return _img;
  }
  set img(value){
    _img = value;
  }

  Map toMap(){
    Map<String, dynamic> map ={
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }
  @override
  String toString(){
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}