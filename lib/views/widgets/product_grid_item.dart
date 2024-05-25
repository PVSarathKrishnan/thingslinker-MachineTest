import 'package:flutter/material.dart';
import 'package:thingslinker/utils/constants.dart';

class ProductGridItem extends StatelessWidget {
  final String title;
  final String description;
  final double amount;
  final String imageUrl;

  const ProductGridItem({
    required this.title,
    required this.description,
    required this.amount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 8), // Add some spacing between image and text
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          truncateText(title, 15),
                          style: textHeading.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          description,
                          style: textNormal.copyWith(
                              fontSize: 14,
                              color: Color.fromARGB(131, 0, 0, 0)),
                          maxLines: 2,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$$amount',
                          style: textHeading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 115,
          top: 5,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.7),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
              child: Text(
                "Best Seller",
                style: textNormal.copyWith(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength - 2)}..';
    }
  }
}
