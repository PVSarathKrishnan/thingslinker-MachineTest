import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thingslinker/utils/constants.dart';
import 'package:thingslinker/views/widgets/best_seller_list.dart';

class ProductListItem extends StatelessWidget {
  final String title;
  final String description;
  final double amount;
  final String imageUrl;
  final int maxTitleLength;

  const ProductListItem({
    required this.title,
    required this.description,
    required this.amount,
    required this.imageUrl,
    this.maxTitleLength = 15, // Default value for max title length
  });

  @override
  Widget build(BuildContext context) {
    // Truncate the title 
    String shortenedTitle = truncateText(title, maxTitleLength);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 22, bottom: 15, left: 22.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 253, 253, 253),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1), 
                ),
              ],
            ),
            child: ListTile(
              leading: Image.network(
                imageUrl,
                height: 125,
                width: 80,
                fit: BoxFit.fill,
              ),
              title: Text(
                shortenedTitle,
                style: textHeading.copyWith(fontSize: 22),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      description,
                      style: textNormal.copyWith(
                          fontSize: 15, color: Color.fromARGB(131, 0, 0, 0)),
                      maxLines: 2,
                    ),
                  ),
                  Text(
                    '\$$amount',
                    style: textHeading.copyWith(color: Colors.black),
                  ),
                ],
              ),
              onTap: () {
                //  item tap 
              },
            ),
          ),
        ),
        BestSellerListWidget()
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
