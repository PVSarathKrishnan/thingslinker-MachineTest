import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thingslinker/repository/api_repository.dart';
import 'package:thingslinker/views/widgets/category_text.dart';
import 'package:thingslinker/views/widgets/product_grid_item.dart';
import 'package:thingslinker/views/widgets/product_list_item.dart';
import 'package:thingslinker/views/widgets/search_bar.dart';
import 'package:thingslinker/utils/constants.dart';

enum SortOptions { popularity, newest, priceHighToLow, priceLowToHigh }

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
  SortOptions _selectedSortOption = SortOptions.popularity;

  String _searchQuery = ''; // Stores the current search query
  Timer? _debounce; // Timer for debounce functionality

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// Filters the list of products based on the search query
  List<dynamic> _filterProducts(List<dynamic> products, String query) {
    return products
        .where((product) =>
            product['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    futureCategories = ApiRepository().fetchUniqueCategories();
    futureProducts = ApiRepository().fetchProducts();
  }

  /// Sorts the products based on the selected sort option
  void _sortProducts(List<dynamic> products) {
    switch (_selectedSortOption) {
      case SortOptions.popularity:
        products.sort((a, b) =>
            (b['reviews']?.length ?? 0).compareTo(a['reviews']?.length ?? 0));
        break;
      case SortOptions.newest:
        products.sort((a, b) => DateTime.parse(b['meta']['createdAt'])
            .compareTo(DateTime.parse(a['meta']['createdAt'])));
        break;
      case SortOptions.priceHighToLow:
        products.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case SortOptions.priceLowToHigh:
        products.sort((a, b) => a['price'].compareTo(b['price']));
        break;
    }
  }

  /// Builds popup menu items for sorting options
  PopupMenuEntry<SortOptions> _buildPopupMenuItem(
      SortOptions option, String text) {
    return PopupMenuItem<SortOptions>(
      value: option,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Icon(
            Icons.circle,
            size: _selectedSortOption == option ? 10 : 12,
            color: _selectedSortOption == option ? Colors.black : Colors.white,
            shadows: _selectedSortOption == option
                ? []
                : [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
          ),
        ],
      ),
    );
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
                    child: FutureBuilder<List<dynamic>>(
                      future: futureProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData) {
                          return Text("No data available");
                        } else {
                          List<String> productTitles = snapshot.data!
                              .map<String>(
                                  (product) => product['title'].toString())
                              .toList();
                          return SearchBarWidget(
                            searchController: searchController,
                            onSearchChanged: _onSearchChanged,
                            suggestions: productTitles,
                          );
                        }
                      },
                    ),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4.0),
                        child: PopupMenuButton<SortOptions>(
                          color: Colors.white,
                          icon: Icon(
                            Icons.tune,
                            color: Colors.black54,
                          ),
                          onSelected: (SortOptions result) {
                            setState(() {
                              _selectedSortOption = result;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<SortOptions>>[
                            _buildPopupMenuItem(
                                SortOptions.popularity, 'Popularity'),
                            _buildPopupMenuItem(SortOptions.newest, 'Newest'),
                            _buildPopupMenuItem(SortOptions.priceHighToLow,
                                'Price: High to Low'),
                            _buildPopupMenuItem(SortOptions.priceLowToHigh,
                                'Price: Low to High'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CategoryText(),
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
                        filteredProducts = _filterProducts(
                            productSnapshot.data!, _searchQuery);
                        currentCategory = 'All Items';
                      } else {
                        currentCategory = categorySnapshot.data![selectedIndex];
                        filteredProducts = _filterProducts(
                          productSnapshot.data!
                              .where((product) =>
                                  product['category'] == currentCategory)
                              .toList(),
                          _searchQuery,
                        );
                      }

                      _sortProducts(filteredProducts);
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

  /// Handles the search query change with debounce
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel(); // Cancel previous timer if active
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _searchQuery = query; // Update search query
        });
      }
    });
  }
}
