import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class CustomSearchableDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final Function(T?) onChanged;
  final String title;
  final String? hint;
  final String? errorText;
  final bool submitted;

  const CustomSearchableDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    required this.title,
    this.hint,
    this.errorText,
    this.submitted = false,
  });

  @override
  State<CustomSearchableDropdown<T>> createState() => _CustomSearchableDropdownState<T>();
}

class _CustomSearchableDropdownState<T> extends State<CustomSearchableDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: AppTextStyle.formTitleStyle(context)),
        Gap(8.h),
        InkWell(
          onTap: () => _showSearchModal(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColor.textFormFillColor(context),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: widget.submitted && widget.value == null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.value != null
                        ? widget.itemLabel(widget.value as T)
                        : (widget.hint ?? widget.title),
                    style: TextStyle(
                      color: widget.value != null
                          ? AppColor.blackColor(context)
                          : Colors.grey.shade600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
        if (widget.submitted && widget.value == null && widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h, right: 12.w),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return _SearchModal<T>(
          items: widget.items,
          itemLabel: widget.itemLabel,
          onSelected: (item) {
            widget.onChanged(item);
            Navigator.pop(context);
          },
          title: widget.title,
        );
      },
    );
  }
}

class _SearchModal<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final Function(T) onSelected;
  final String title;

  const _SearchModal({
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    required this.title,
  });

  @override
  State<_SearchModal<T>> createState() => _SearchModalState<T>();
}

class _SearchModalState<T> extends State<_SearchModal<T>> {
  late List<T> filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => widget.itemLabel(item).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: AppTextStyle.formTitleStyle(context)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          Gap(12.h),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "بحث...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            onChanged: _filterItems,
          ),
          Gap(12.h),
          Expanded(
            child: ListView.separated(
              itemCount: filteredItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  title: Text(widget.itemLabel(item)),
                  onTap: () => widget.onSelected(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
