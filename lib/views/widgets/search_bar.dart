import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:thingslinker/utils/constants.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: gr,
        contentPadding: const EdgeInsets.all(16.0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            BootstrapIcons.search,
            size: 20,
            color: Colors.black54,
          ),
        ),
        suffixIcon: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.center_focus_weak_rounded,
            color: Colors.black54,
            size: 25,
          ),
        ),
        hintText: 'Search...',
        hintStyle: textNormal.copyWith(color: Colors.black45),
      ),
    );
  }
}
