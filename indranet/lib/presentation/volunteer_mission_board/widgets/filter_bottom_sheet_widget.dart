import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  double _distanceRadius = 10.0;
  List<String> _selectedMissionTypes = [];
  List<String> _selectedSkills = [];

  final List<String> _missionTypes = [
    'Rescue',
    'Medical',
    'Supply',
    'Evacuation',
    'Search',
    'Relief',
  ];

  final List<String> _availableSkills = [
    'First Aid',
    'Medical Training',
    'Search & Rescue',
    'Communication',
    'Transportation',
    'Logistics',
    'Translation',
    'Counseling',
    'Technical Skills',
    'Heavy Lifting',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _distanceRadius = (_filters['distanceRadius'] as double?) ?? 10.0;
    _selectedMissionTypes = List<String>.from(_filters['missionTypes'] ?? []);
    _selectedSkills = List<String>.from(_filters['skills'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Missions',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance radius
                  _buildSectionTitle('Distance Radius'),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Within ${_distanceRadius.toInt()} km',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${_distanceRadius.toInt()} km',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            thumbColor: AppTheme.lightTheme.colorScheme.primary,
                            overlayColor: AppTheme
                                .lightTheme.colorScheme.primary
                                .withValues(alpha: 0.2),
                            inactiveTrackColor: Colors.grey[300],
                            trackHeight: 4.0,
                          ),
                          child: Slider(
                            value: _distanceRadius,
                            min: 1.0,
                            max: 50.0,
                            divisions: 49,
                            onChanged: (value) {
                              setState(() {
                                _distanceRadius = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Mission types
                  _buildSectionTitle('Mission Types'),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _missionTypes.map((type) {
                      final isSelected = _selectedMissionTypes.contains(type);
                      return GestureDetector(
                        onTap: () => _toggleMissionType(type),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: _getMissionTypeIcon(type),
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                type,
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 3.h),

                  // Skills matching
                  _buildSectionTitle('Skills Matching'),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _availableSkills.map((skill) {
                      final isSelected = _selectedSkills.contains(skill);
                      return GestureDetector(
                        onTap: () => _toggleSkill(skill),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.secondary
                                : AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.lightTheme.colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Apply Filters',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
    );
  }

  void _toggleMissionType(String type) {
    setState(() {
      if (_selectedMissionTypes.contains(type)) {
        _selectedMissionTypes.remove(type);
      } else {
        _selectedMissionTypes.add(type);
      }
    });
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      _distanceRadius = 10.0;
      _selectedMissionTypes.clear();
      _selectedSkills.clear();
    });
  }

  void _applyFilters() {
    final filters = {
      'distanceRadius': _distanceRadius,
      'missionTypes': _selectedMissionTypes,
      'skills': _selectedSkills,
    };
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  String _getMissionTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'rescue':
        return 'emergency';
      case 'medical':
        return 'medical_services';
      case 'supply':
        return 'local_shipping';
      case 'evacuation':
        return 'directions_run';
      case 'search':
        return 'search';
      case 'relief':
        return 'volunteer_activism';
      default:
        return 'help';
    }
  }
}
