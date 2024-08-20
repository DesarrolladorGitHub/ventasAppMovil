import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventas_app/src/providers/user_provider.dart';

import '../models/product.model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<DetailScreen> createState() => _DetailState();
}

class _DetailState extends State<DetailScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int _id;
  final numberFormat = NumberFormat.currency(locale: 'af', symbol: "\$");

  @override
  void initState() {
    _id = widget.id ?? 0;
    super.initState();
  }

  Future<ProductModel?> _getData(int id) async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products/$id'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return ProductModel.fromJson(data);
    }
    return null;
  }

  void pressMap() {
    Navigator.pushNamed(context, '/map');
  }

  void pressContact() {
    Navigator.pushNamed(context, '/contact');
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context);
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Detalle Anuncio"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(children: [
        Text(providerUser.name),
        Expanded(
          child: FutureBuilder(
            future: _getData(_id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Image(
                                image: AssetImage(
                                    'assets/images/${snapshot.data?.category}.jpg'),
                                fit: BoxFit.cover),
                          )
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(snapshot.data?.title ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                          Expanded(
                            flex: 2,
                            child: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(Icons.star_rate, size: 16),
                                  ),
                                  TextSpan(
                                      text: snapshot.data?.rating.toString() ??
                                          "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(
                                  numberFormat.format(snapshot.data?.price),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.blue),
                              ),
                              onPressed: () => pressMap(),
                              child: const Text("Mapa", style: TextStyle(color: Colors.white, fontSize: 10)),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(snapshot.data?.description ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue),
                          ),
                          onPressed: () => pressContact(),
                          child: const Text("Contactar Vendedor", style: TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ),
                    ]),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ]),
    ));
  }
}
