
import 'package:flutter/material.dart';
import 'package:thingslinker/utils/constants.dart';

class CategoryText extends StatelessWidget {
  const CategoryText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 15,
      ),
      child: Text(
        "Category",
        style: textHeading,
      ),
    );
  }
}
