import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  final CollectionReference books =
    FirebaseFirestore.instance.collection("Kitaplar");
  Future<void> addBook(Object kitap){
    return books.add(kitap);
  }

  Stream<QuerySnapshot> getBook(){
    final bookData = books.snapshots();
    return bookData;
  }
  Future<void> guncelle(String bookId,String ad,String yayin,String kategori,String yazar,int sayfa,int yil,bool liste){
    return books.doc(bookId).update({'ad':ad,'yayin':yayin,'kategori':kategori,'yazar':yazar,'yil':yil,'liste':liste});
  }

  Future<void> sil(String bookId){
    return books.doc(bookId).delete();
  }
  
}

/*

*/





/*
body:StreamBuilder<QuerySnapshot>(
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
                  return ListTile(
                    title: Text(kitapAd),
                  );

                });
              }
              else{
                return const Text("Kitap Ekleyin");
              }
            },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed:()=>  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>Anasayfa())),
        child: const Icon(Icons.add),
      ),

*/