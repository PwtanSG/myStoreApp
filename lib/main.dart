import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Product>> _getProducts() async {
    var data = await http.get(Uri.parse('http://180.140.66.77:8080/product'));
    var jsonData = json.decode(data.body);
    var jsonDataProd = jsonData['Products'];

    List<Product> products = [];
    for (var a in jsonDataProd) {
      String imageurl = a['imageurl'];
      Product album = Product(
          id: a['productid'],
          name: a['name'],
          price: a['price'],
          description: a['description'],
          image: imageurl.substring(1));
      products.add(album);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Store App'),
          centerTitle: true,
        ),
        body: Center(
          child: FutureBuilder(
            future: _getProducts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                //return Container(
                //  child: const Center(
                //    child: Text('Loading...'),
                //  ),
                //);
                return const CircularProgressIndicator();
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      //print(snapshot.data[index].image);
                      return ListTile(
                        leading: SizedBox(
                          height: 150.0,
                          width: 150.0, // fixed width and height
                          child: Image.asset(
                            snapshot.data[index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(snapshot.data[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        subtitle:
                            Text("\$ " + snapshot.data[index].price.toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(snapshot.data[index])));
                        },
                      );
                    });
              }
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: IconButton(
              onPressed: () {
                // ignore: avoid_print
                print('test');
              },
              icon: const Icon(Icons.home, color: Colors.white)),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Product product;

  DetailPage(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Column(
        children: [
          Image.asset(
            product.image,
            width: 600,
            height: 240,
            fit: BoxFit.cover,
          ),
          Text(product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          Text('\$' + product.price.toString()),
          Text(
            product.description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String image;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.image});
}
