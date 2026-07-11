import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final List<T>? items;
  final T? selectedItem;
  final String Function(T item) itemAsString;
  final void Function(T? value)? onChanged;
  final bool enabled;
  final double popupHeight;
  final Future<List<T>> Function(String filter)? asyncItems;

  const CustomDropdownSearch({
    super.key,
    this.label = '',
    this.hintText,
    this.items,
    required this.itemAsString,
    this.selectedItem,
    this.onChanged,
    this.enabled = true,
    this.popupHeight = 300,
    this.asyncItems,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      enabled: enabled,
      items: (filter, loadProps) async {
        if (asyncItems != null) {
          return await asyncItems!(filter);
        }

        final f = filter.toLowerCase();
        if (f.isEmpty) {
          return items?? const [];
        }
        return (items ?? const [])
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
          labelText: label.isNotEmpty? label : null,
          hintText: hintText,
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