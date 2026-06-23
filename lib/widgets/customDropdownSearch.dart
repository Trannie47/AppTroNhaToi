import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) itemAsString;
  final void Function(T? value)? onChanged;
  final bool enabled;

  /// Chiều cao popup
  final double popupHeight;

  const CustomDropdownSearch({
    super.key,
    this.label = '',
    required this.items,
    required this.itemAsString,
    this.selectedItem,
    this.onChanged,
    this.enabled = true,
    this.popupHeight = 300,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      enabled: enabled,
      items: (filter, _) {
        final f = filter.toLowerCase();

        if (f.isEmpty) {
          return items;
        }

        return items
            .where((e) => itemAsString(e).toLowerCase().contains(f))
            .toList();
      },
      selectedItem: selectedItem,
      itemAsString: itemAsString,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        constraints: BoxConstraints(maxHeight: popupHeight),
        searchFieldProps: const TextFieldProps(
          decoration: InputDecoration(
            hintText: "Tìm kiếm...",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      onSelected: onChanged,
      compareFn: (a, b) => a == b,
    );
  }
}
