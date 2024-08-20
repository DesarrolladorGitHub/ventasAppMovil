import 'dart:convert';

import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:ventas_app/src/models/product.model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ventas_app/src/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  static const _pageSize = 5;
  late String _category = 'smartphones';
  final TextEditingController _searchController = TextEditingController();
  late List<ProductModel> products = [];
  late List<ProductModel> productsFilter = [];
  final numberFormat = NumberFormat.currency(locale: 'af', symbol: "\$");

  final PagingController<int, ProductModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<List<ProductModel>> _getData(String category) async {
    products = [];
    final response = await http
        .get(Uri.parse('https://dummyjson.com/products/category/$category'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data['products']) {
        products.add(ProductModel.fromJson(index));
      }
      productsFilter = products;
      _pagingController.refresh();
      return products;
    }
    return products;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = productsFilter.skip(pageKey).take(_pageSize).toList();
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void search(String s) {
    productsFilter =
        products.where((i) => i.title.toLowerCase().contains(s)).toList();
    _pagingController.refresh();
  }

  void pressDetail(int id) {
    Navigator.pushNamed(context, '/detail', arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context);
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Buscador Anuncios"),
      ),
      body: Column(children: [
        Text(providerUser.name),
        Container(
          padding: const EdgeInsets.all(8.0),
          height: 100,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                height: 30,
                padding: const EdgeInsets.only(left: 5.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: _category == 'smartphones'
                        ? WidgetStateProperty.all(Colors.green)
                        : WidgetStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    setState(() => _category = 'smartphones');
                  },
                  child: const Text("Celulares", style: TextStyle(color: Colors.white, fontSize: 10),),
                ),
              )),
              Expanded(
                  child: Container(
                height: 30,
                padding: const EdgeInsets.only(left: 5.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: _category == 'vehicle'
                        ? WidgetStateProperty.all(Colors.green)
                        : WidgetStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    setState(() => _category = 'vehicle');
                  },
                  child: const Text("Autos", style: TextStyle(color: Colors.white, fontSize: 10),),
                ),
              )),
              Expanded(
                  child: Container(
                height: 30,
                padding: const EdgeInsets.only(left: 5.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: _category == 'laptops'
                          ? WidgetStateProperty.all(Colors.green)
                          : WidgetStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    setState(() => _category = 'laptops');
                  },
                  child: const Text("Laptops", style: TextStyle(color: Colors.white, fontSize: 10),),
                ),
              )),
            ],
          ),
        ),
        SizedBox(
          height: 45,
          width: 360,
          child: TextField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xfff1f1f1),
              hintText: "Buscar..",
              prefixIcon: Icon(Icons.search),
              prefixIconColor: Colors.black,
            ),
            controller: _searchController,
            onChanged: search,
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _getData(_category),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PagedListView<int, ProductModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ProductModel>(
                      itemBuilder: (context, item, index) {
                    return GestureDetector(
                      onTap: () => {pressDetail(item.id)},
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/images/$_category.jpg'),
                                      fit: BoxFit.cover),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(item.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                              numberFormat.format(item.price),
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12))),
                                    ]),
                                    Text(item.description,
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  }),
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
