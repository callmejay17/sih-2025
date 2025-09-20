import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedTypes;
  final bool showOfflineOnly;
  final Function(List<String>, List<String>, bool) onApplyFilters;

  const FilterBottomSheet({
    Key? key,
    required this.selectedCategories,
    required this.selectedTypes,
    required this.showOfflineOnly,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedCategories;
  late List<String> _selectedTypes;
  late bool _showOfflineOnly;

  final List<String> _categories = [
    'Earthquake',
    'Flood',
    'Cyclone',
    'Fire',
    'General Emergency',
  ];

  final List<String> _types = [
    'Checklist',
    'Guide',
    'Emergency',
    'First Aid',
    'Evacuation',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
    _selectedTypes = List.from(widget.selectedTypes);
    _showOfflineOnly = widget.showOfflineOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Resources',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategories.clear();
                          _selectedTypes.clear();
                          _showOfflineOnly = false;
                        });
                      },
                      child: Text(
                        'Clear All',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  'Categories',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _categories.map((category) {
                    final isSelected = _selectedCategories.contains(category);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedCategories.remove(category);
                          } else {
                            _selectedCategories.add(category);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryLight
                              : AppTheme.lightTheme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryLight
                                : AppTheme.dividerLight,
                          ),
                        ),
                        child: Text(
                          category,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.onPrimaryLight
                                : AppTheme.textSecondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Resource Types',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _types.map((type) {
                    final isSelected = _selectedTypes.contains(type);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedTypes.remove(type);
                          } else {
                            _selectedTypes.add(type);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.secondaryLight
                              : AppTheme.lightTheme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.secondaryLight
                                : AppTheme.dividerLight,
                          ),
                        ),
                        child: Text(
                          type,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.onSecondaryLight
                                : AppTheme.textSecondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Show Offline Only',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                    Switch(
                      value: _showOfflineOnly,
                      onChanged: (value) {
                        setState(() {
                          _showOfflineOnly = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onApplyFilters(
                            _selectedCategories,
                            _selectedTypes,
                            _showOfflineOnly,
                          );
                          Navigator.pop(context);
                        },
                        child: Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
