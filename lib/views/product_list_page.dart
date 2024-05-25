import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingslinker/repository/api_repository.dart';
import 'package:thingslinker/views/widgets/product_grid_item.dart';
import 'package:thingslinker/views/widgets/product_list_item.dart';
import 'package:thingslinker/views/widgets/search_bar.dart';
import 'package:thingslinker/utils/constants.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  TextEditingController searchController = TextEditingController();
  late Future<List<String>> futureCategories;
  late Future<List<dynamic>> futureProducts;
  int selectedIndex = -1;
  bool showGridView = true;

  @override
  void initState() {
    super.initState();
    futureCategories = ApiRepository().fetchUniqueCategories();
    futureProducts = ApiRepository().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight / 30),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 25,
                    ),
                    child: SearchBarWidget(searchController: searchController),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 18.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: screenWidth / 8,
                      height: screenHeight / 17,
                      decoration: BoxDecoration(
                        color: gr,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.tune,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          //func
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 15,
              ),
              child: Text(
                "Category",
                style: textHeading,
              ),
            ),
            SizedBox(
              height: 40.0,
              child: FutureBuilder<List<String>>(
                future: futureCategories,
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    List<String> categories = ['All Items', ...snapshot.data!];
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      itemCount: categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 15.0),
                      itemBuilder: (context, index) {
                        final isSelected = selectedIndex == index - 1;
                        return TextButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = index - 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: isSelected ? Colors.black : gr,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("Error: ${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            FutureBuilder<List<dynamic>>(
              future: futureProducts,
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> productSnapshot) {
                return FutureBuilder<List<String>>(
                  future: futureCategories,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> categorySnapshot) {
                    if (productSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        categorySnapshot.connectionState ==
                            ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (productSnapshot.hasError ||
                        categorySnapshot.hasError) {
                      return Text(
                          "Error: ${productSnapshot.error ?? categorySnapshot.error}");
                    } else if (!productSnapshot.hasData ||
                        !categorySnapshot.hasData) {
                      return Text("No data available");
                    } else {
                      List<dynamic> filteredProducts;
                      String currentCategory;
                      if (selectedIndex == -1) {
                        filteredProducts = productSnapshot.data!;
                        currentCategory = 'All Items';
                      } else {
                        currentCategory = categorySnapshot.data![selectedIndex];
                        filteredProducts = productSnapshot.data!
                            .where((product) =>
                                product['category'] == currentCategory)
                            .toList();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentCategory,
                                      style: textHeading,
                                    ),
                                    Text(
                                      '${filteredProducts.length} items',
                                      style: textNormal.copyWith(
                                          color: Color.fromARGB(142, 0, 0, 0)),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: screenWidth / 10,
                                  height: screenHeight / 20,
                                  decoration: BoxDecoration(
                                    color: gr,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      showGridView
                                          ? Icons.menu
                                          : Icons.grid_view,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showGridView =
                                            !showGridView; // Toggle the layout mode
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          showGridView
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      var product = filteredProducts[index];
                                      return ProductGridItem(
                                        title: product['title'],
                                        description: product['description'],
                                        amount: product['price'],
                                        imageUrl: product['thumbnail'],
                                      );
                                    },
                                  ),
                                )
                              : Column(
                                  children:
                                      filteredProducts.map<Widget>((product) {
                                    return ProductListItem(
                                      title: product['title'],
                                      description: product['description'],
                                      amount: product['price'],
                                      imageUrl: product['thumbnail'],
                                    );
                                  }).toList(),
                                ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
