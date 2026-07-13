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
    final primary = Theme.of(context).colorScheme.primary;

    return DropdownSearch<T>(
      enabled: enabled,

      items: (filter, loadProps) async {
        if (asyncItems != null) {
          return await asyncItems!(filter);
        }

        final keyword = filter.toLowerCase();

        if (keyword.isEmpty) {
          return items ?? <T>[];
        }

        return (items ?? <T>[])
            .where(
              (e) => itemAsString(e)
              .toLowerCase()
              .contains(keyword),
        )
            .toList();
      },

      selectedItem: selectedItem,
      itemAsString: itemAsString,
      compareFn: (a, b) => a == b,
      onSelected: onChanged,

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: label.isEmpty ? null : label,
          hintText: hintText,
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: primary,
              width: 2,
            ),
          ),

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
        ),
      ),

      popupProps: PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        constraints: BoxConstraints(
          maxHeight: popupHeight,
        ),

        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Tìm kiếm...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade100,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: primary,
                width: 1.5,
              ),
            ),
          ),
        ),

        itemBuilder: (
            BuildContext context,
            T item,
            bool isDisabled,
            bool isSelected,
            ) {
          return Container(
            height: 48,

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            decoration: BoxDecoration(
              color: isSelected
                  ? primary.withValues(alpha: 0.08)
                  : Colors.transparent,

              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 0.8,
                ),
              ),
            ),

            child: Row(
              children: [
                Expanded(
                  child: Text(
                    itemAsString(item),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),

                if (isSelected)
                  Icon(
                    Icons.check,
                    color: primary,
                    size: 18,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}