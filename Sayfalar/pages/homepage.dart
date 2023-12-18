import 'package:firebase_deneme/main.dart';
import 'package:firebase_deneme/services/firestore.dart';
import 'package:flutter/material.dart';

class Anasayfa extends StatefulWidget {
  
  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

void showSnackBar(BuildContext context) {
  final snackBar = SnackBar(
    content: Text('"Sayfa Sayısı" ve "Basım Yılı" bölümlerine sadece sayı girilebilir.'),
    duration: Duration(seconds: 10),
    action: SnackBarAction(
      label: 'Kapat',
      onPressed: () {
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


class _AnasayfaState extends State<Anasayfa> {
  Map<String, dynamic> kitap = {};
  bool intDenetleyici = false;
  final FirestoreService firestore = FirestoreService();
  final TextEditingController adController = TextEditingController();
  final TextEditingController yayinController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController yazarController = TextEditingController();
  final TextEditingController sayfaController = TextEditingController();
  final TextEditingController basimController = TextEditingController();
  final TextEditingController listeController = TextEditingController();
  bool shouldPublish = false;
    void dispose() {
    adController.dispose();
    yayinController.dispose();
    kategoriController.dispose();
    yazarController.dispose();
    sayfaController.dispose();
    basimController.dispose();
    listeController.dispose();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 6000,
      color: Colors.white,
      alignment: const FractionalOffset(0.5, 0.75),
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      constraints: const BoxConstraints(maxHeight: 500),
      child:Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Kitap Ekle veya Düzenle"),
        ),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children:<Widget>[
            TextField(
              controller: adController,
              obscureText: false,
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Kitap adı',),
              onChanged:(value) {
                kitap['ad'] = value;

              },
            ),
             TextField(
              controller: yayinController,
              obscureText: false,
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Yayınevi',),
              onChanged:(value) {
                kitap['yayin'] = value;
              },
            ),
            DropdownButtonFormField(
              hint: const Text("Kategori Seç"),items: const [
              DropdownMenuItem(value: "Roman",child: Text("Roman"),),
              DropdownMenuItem(value: "Tarih",child: Text("Tarih"),),
              DropdownMenuItem(value: "Edebiyat",child: Text("Edebiyat"),),
              DropdownMenuItem(value: "Şiir",child: Text("Şiir"),),
              DropdownMenuItem(value: "Ansiklopedi",child: Text("Ansiklopedi"),),
            ],onChanged: (value) => {kitap['kategori']=value} 
            ),
            TextField(
              controller: yazarController,
              obscureText: false,
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Yazarlar',),
              onChanged:(value) {
                kitap['yazar'] = value;
              },
            ),
            TextField(
              controller: sayfaController,
              obscureText: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Sayfa Sayısı',),
              onChanged:(value) {
                if (value.isNotEmpty) {
                  if (int.tryParse(value) == null) {
                    intDenetleyici = true;
                  }
                    else{kitap['sayfa'] = value;
                    intDenetleyici=false;}
                
              }
              }
            ),
            TextField(
              controller: basimController,
              obscureText: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Basım Yılı',),
              onChanged:(value) {
                if (value.isNotEmpty) {
                  if (int.tryParse(value) == null) {
                    intDenetleyici = true;
                  }
                    else{kitap['yil'] = value;
                    intDenetleyici=false;}
                
              }
              },
            ),
            CheckboxListTile(
            title: Text('Kitap Yayınlansın mı?'),
            value: shouldPublish,
            onChanged: (bool? newValue) {
              setState(() {
                shouldPublish = newValue ?? false;
              });
              kitap['liste'] = shouldPublish;}
              ),
            ElevatedButton(onPressed: () {
              String enteredText=sayfaController.text;
              String enteredText1=basimController.text;
              int?enterednumber=int.tryParse(enteredText1);
              int?enterednumber1=int.tryParse(enteredText);
              print(enterednumber);
              if(int.tryParse(enteredText1)==null|| int.tryParse(enteredText) ==null){
                kitap['sayi'];kitap['yil']=null;
                return showSnackBar(context);
              }
              else{
              if(kitap['ad']==null){
                kitap['ad'] = 'Tanımlanmadı';
              }
              if(kitap['yayin']==null){
                kitap['yayin'] = 'Tanımlanmadı';
              }
              if(kitap['yazar']==null){
                kitap['yazar']="Tanımlanmadı";
              }
              if(kitap['kategori']==null){
                kitap['kategori']="Tanımlanmadı";
              }
              
              if(enterednumber==null){
                kitap['yil']='0';
              }
              if(enterednumber1==null){
                kitap['sayfa']='0';
              }
              kitap['liste'] = shouldPublish;
            firestore.addBook(kitap);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>MyApp()));
              }
        }, child: Text("Kaydet"),),
  ],
        ),
        
      ),
      ),
    );
  }
}