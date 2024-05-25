import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:thingslinker/utils/constants.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
    required this.suggestions,
  }) : super(key: key);

  final TextEditingController searchController;
  final void Function(String) onSearchChanged;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return suggestions.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        searchController.text = selection;
        onSearchChanged(selection);
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        fieldTextEditingController.text = searchController.text;
        return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          onChanged: (String query) {
            onSearchChanged(query);
          },
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
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      onSearchChanged('');
                    },
                    color: Colors.black54,
                  )
                : const Padding(
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
      },
    );
  }
}
