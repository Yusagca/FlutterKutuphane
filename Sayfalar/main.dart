import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/homepage.dart';
import './services/firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halil Yuşa Ağca Kütüphane',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Halil Yuşa Ağca Kütüphanesi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirestoreService firestore = FirestoreService();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:()=>  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>Anasayfa())),
        child: const Icon(Icons.add),
      ),
      body:Container(
        alignment: const FractionalOffset(0.5, 0.75),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        constraints: const BoxConstraints(maxHeight: 1000),
        child:StreamBuilder<QuerySnapshot>(
            stream:firestore.getBook(),
            builder:(context, snapshot) {
              if(snapshot.hasData){
                List bookList = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: bookList.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot document = bookList[index];
                    String bookId = document.id;
                    Map<String,dynamic> data = 
                    document.data() as Map<String,dynamic>;
                  String kitapAd = data['ad'];
                  String kitapSayfa = data['sayfa'];
                  String kitapYazar = data['yazar'];
                  bool yayin = data['liste'];
                  if (yayin==true){
                   return Container(
                    margin: const EdgeInsets.all(3),
                    padding:const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    decoration: BoxDecoration(
                    color:Color.fromARGB(255, 229, 255, 232) ,
                    borderRadius: BorderRadius.circular(20.0),),
                    child:ListTile(
                    title: Text(kitapAd,style:TextStyle(fontWeight: FontWeight.bold,)),
                    subtitle: Text("Yazar:"+kitapYazar+", Sayfa Sayısı:"+kitapSayfa,style:TextStyle(fontSize:14,)),
                    trailing:Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                    IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>Anasayfa()));
                      firestore.sil(bookId);
                    },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                                
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Silmek İstediğinize Emin Misiniz?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Vazgeç.'),
                          ),
                          TextButton(
                            onPressed: () {
                            firestore.sil(bookId);
                             Navigator.of(context).pop();
                            },
                            child: Text('Sil'),
                          )
                          ]
                          );
                          }
                          );
                          },
                        )
                        ]
                        )
                        )
                        );
                  }else{
                    return SizedBox();
                  }
                      });
                    }
              else{
                return const Text("Kitap Ekleyin");
              }
            },
            ),
    ),
          bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Kitaplar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Satın Al',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ayarlar',
            ),
          ],
    )
    );
  }
}
