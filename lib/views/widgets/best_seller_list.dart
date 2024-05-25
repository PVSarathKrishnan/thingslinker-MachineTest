
import 'package:flutter/material.dart';
import 'package:thingslinker/utils/constants.dart';

class BestSellerListWidget extends StatelessWidget {
  const BestSellerListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 310,
      top: 10,
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
    );
  }
}
