import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/quick_access_toolbar.dart';
import './widgets/resource_category_card.dart';
import './widgets/resource_detail_card.dart';
import './widgets/search_bar_widget.dart';

class SafetyResourcesLibrary extends StatefulWidget {
  const SafetyResourcesLibrary({Key? key}) : super(key: key);

  @override
  State<SafetyResourcesLibrary> createState() => _SafetyResourcesLibraryState();
}

class _SafetyResourcesLibraryState extends State<SafetyResourcesLibrary>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  List<String> _selectedCategories = [];
  List<String> _selectedTypes = [];
  bool _showOfflineOnly = false;
  Set<String> _bookmarkedResources = {};

  final List<Map<String, dynamic>> _categories = [
    {
      "id": "earthquake",
      "title": "Earthquake Safety",
      "iconName": "vibration",
      "resourceCount": 12,
      "color": const Color(0xFFD32F2F),
    },
    {
      "id": "flood",
      "title": "Flood Preparedness",
      "iconName": "water",
      "resourceCount": 8,
      "color": const Color(0xFF1976D2),
    },
    {
      "id": "cyclone",
      "title": "Cyclone Safety",
      "iconName": "air",
      "resourceCount": 6,
      "color": const Color(0xFF7B1FA2),
    },
    {
      "id": "fire",
      "title": "Fire Emergency",
      "iconName": "local_fire_department",
      "resourceCount": 10,
      "color": const Color(0xFFE64A19),
    },
    {
      "id": "general",
      "title": "General Emergency",
      "iconName": "emergency",
      "resourceCount": 15,
      "color": const Color(0xFF388E3C),
    },
  ];

  final List<Map<String, dynamic>> _resources = [
    {
      "id": "1",
      "title": "Earthquake Emergency Kit Checklist",
      "description":
          "Complete checklist of essential items to keep ready for earthquake emergencies including food, water, medical supplies, and important documents.",
      "type": "Checklist",
      "category": "Earthquake",
      "isOfflineAvailable": true,
      "fileSize": "2.5 MB",
      "content": "Essential items for earthquake preparedness...",
    },
    {
      "id": "2",
      "title": "Drop, Cover, and Hold On Guide",
      "description":
          "Step-by-step instructions on the proper earthquake safety technique recommended by emergency experts worldwide.",
      "type": "Guide",
      "category": "Earthquake",
      "isOfflineAvailable": true,
      "fileSize": "1.8 MB",
      "content": "When you feel shaking or hear earthquake warning...",
    },
    {
      "id": "3",
      "title": "Flood Evacuation Planning",
      "description":
          "Comprehensive guide for creating family evacuation plans during flood emergencies, including route planning and communication strategies.",
      "type": "Evacuation",
      "category": "Flood",
      "isOfflineAvailable": false,
      "fileSize": "3.2 MB",
      "content": "Create your family evacuation plan...",
    },
    {
      "id": "4",
      "title": "Basic First Aid for Disasters",
      "description":
          "Essential first aid techniques for common injuries during natural disasters, including wound care, CPR basics, and emergency medical procedures.",
      "type": "First Aid",
      "category": "General Emergency",
      "isOfflineAvailable": true,
      "fileSize": "4.1 MB",
      "content": "Basic first aid procedures for emergencies...",
    },
    {
      "id": "5",
      "title": "Cyclone Safety Measures",
      "description":
          "Protective actions to take before, during, and after cyclones including home preparation, evacuation procedures, and post-storm safety.",
      "type": "Guide",
      "category": "Cyclone",
      "isOfflineAvailable": true,
      "fileSize": "2.9 MB",
      "content": "Cyclone safety and preparation guidelines...",
    },
    {
      "id": "6",
      "title": "Fire Escape Plan Template",
      "description":
          "Downloadable template for creating home fire escape plans with multiple exit routes and family meeting points.",
      "type": "Checklist",
      "category": "Fire",
      "isOfflineAvailable": false,
      "fileSize": "1.5 MB",
      "content": "Create your fire escape plan...",
    },
    {
      "id": "7",
      "title": "Emergency Communication Plan",
      "description":
          "Guide for establishing communication protocols with family members during disasters when normal communication channels may be disrupted.",
      "type": "Guide",
      "category": "General Emergency",
      "isOfflineAvailable": true,
      "fileSize": "2.1 MB",
      "content": "Emergency communication strategies...",
    },
    {
      "id": "8",
      "title": "Water Purification Methods",
      "description":
          "Various methods to purify water during emergencies when clean water supply is compromised, including boiling, chemical treatment, and filtration.",
      "type": "Guide",
      "category": "General Emergency",
      "isOfflineAvailable": true,
      "fileSize": "1.7 MB",
      "content": "Water purification techniques for emergencies...",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredResources {
    return _resources.where((resource) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final title = (resource["title"] as String).toLowerCase();
        final description =
            (resource["description"] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!title.contains(query) && !description.contains(query)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategories.isNotEmpty) {
        if (!_selectedCategories.contains(resource["category"] as String)) {
          return false;
        }
      }

      // Type filter
      if (_selectedTypes.isNotEmpty) {
        if (!_selectedTypes.contains(resource["type"] as String)) {
          return false;
        }
      }

      // Offline filter
      if (_showOfflineOnly) {
        if (!(resource["isOfflineAvailable"] as bool)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _bookmarkedResourcesList {
    return _resources.where((resource) {
      return _bookmarkedResources.contains(resource["id"] as String);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Safety Resources',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimaryLight,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showShareDialog(),
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.textPrimaryLight,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Resources'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      body: Column(
        children: [
          QuickAccessToolbar(
            onEmergencyContactsTap: () => _showEmergencyContacts(),
            onLocationShareTap: () => _shareLocation(),
            onSavedResourcesTap: () => _tabController.animateTo(1),
          ),
          SearchBarWidget(
            hintText: 'Search safety resources...',
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            onFilterTap: () => _showFilterBottomSheet(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildResourcesTab(),
                _buildSavedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchQuery.isEmpty &&
              _selectedCategories.isEmpty &&
              _selectedTypes.isEmpty &&
              !_showOfflineOnly) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Text(
                'Browse by Category',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ),
            ...(_categories as List).map((dynamic category) {
              final categoryMap = category as Map<String, dynamic>;
              return ResourceCategoryCard(
                title: categoryMap["title"] as String,
                iconName: categoryMap["iconName"] as String,
                resourceCount: categoryMap["resourceCount"] as int,
                categoryColor: categoryMap["color"] as Color,
                onTap: () => _selectCategory(categoryMap["title"] as String),
              );
            }).toList(),
            SizedBox(height: 2.h),
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _searchQuery.isNotEmpty ||
                          _selectedCategories.isNotEmpty ||
                          _selectedTypes.isNotEmpty ||
                          _showOfflineOnly
                      ? 'Filtered Resources (${_filteredResources.length})'
                      : 'All Resources',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                if (_selectedCategories.isNotEmpty ||
                    _selectedTypes.isNotEmpty ||
                    _showOfflineOnly)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategories.clear();
                        _selectedTypes.clear();
                        _showOfflineOnly = false;
                        _searchQuery = '';
                      });
                    },
                    child: Text(
                      'Clear Filters',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_filteredResources.isEmpty)
            Container(
              padding: EdgeInsets.all(8.w),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'search_off',
                    color: AppTheme.textDisabledLight,
                    size: 15.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No resources found',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Try adjusting your search or filters',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textDisabledLight,
                    ),
                  ),
                ],
              ),
            )
          else
            ...(_filteredResources as List).map((dynamic resource) {
              final resourceMap = resource as Map<String, dynamic>;
              return ResourceDetailCard(
                title: resourceMap["title"] as String,
                description: resourceMap["description"] as String,
                type: resourceMap["type"] as String,
                isBookmarked:
                    _bookmarkedResources.contains(resourceMap["id"] as String),
                isOfflineAvailable: resourceMap["isOfflineAvailable"] as bool,
                fileSize: resourceMap["fileSize"] as String?,
                onTap: () => _openResourceDetail(resourceMap),
                onBookmarkTap: () =>
                    _toggleBookmark(resourceMap["id"] as String),
                onDownloadTap: () => _downloadResource(resourceMap),
              );
            }).toList(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSavedTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Text(
              'Saved Resources (${_bookmarkedResourcesList.length})',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
            ),
          ),
          if (_bookmarkedResourcesList.isEmpty)
            Container(
              padding: EdgeInsets.all(8.w),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'bookmark_border',
                    color: AppTheme.textDisabledLight,
                    size: 15.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No saved resources',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Bookmark resources to access them quickly',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textDisabledLight,
                    ),
                  ),
                ],
              ),
            )
          else
            ...(_bookmarkedResourcesList as List).map((dynamic resource) {
              final resourceMap = resource as Map<String, dynamic>;
              return ResourceDetailCard(
                title: resourceMap["title"] as String,
                description: resourceMap["description"] as String,
                type: resourceMap["type"] as String,
                isBookmarked: true,
                isOfflineAvailable: resourceMap["isOfflineAvailable"] as bool,
                fileSize: resourceMap["fileSize"] as String?,
                onTap: () => _openResourceDetail(resourceMap),
                onBookmarkTap: () =>
                    _toggleBookmark(resourceMap["id"] as String),
                onDownloadTap: () => _downloadResource(resourceMap),
              );
            }).toList(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategories = [category];
    });
  }

  void _toggleBookmark(String resourceId) {
    setState(() {
      if (_bookmarkedResources.contains(resourceId)) {
        _bookmarkedResources.remove(resourceId);
        Fluttertoast.showToast(
          msg: "Removed from saved resources",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        _bookmarkedResources.add(resourceId);
        Fluttertoast.showToast(
          msg: "Added to saved resources",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  void _openResourceDetail(Map<String, dynamic> resource) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildResourceDetailModal(resource),
    );
  }

  Widget _buildResourceDetailModal(Map<String, dynamic> resource) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    resource["title"] as String,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondaryLight,
                    size: 6.w,
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
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      resource["type"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    resource["description"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Content Preview',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.dividerLight),
                    ),
                    child: Text(
                      resource["content"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimaryLight,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareResource(resource),
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.primaryLight,
                      size: 4.w,
                    ),
                    label: const Text('Share'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadResource(resource),
                    icon: CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.onPrimaryLight,
                      size: 4.w,
                    ),
                    label: const Text('Download'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedCategories: _selectedCategories,
        selectedTypes: _selectedTypes,
        showOfflineOnly: _showOfflineOnly,
        onApplyFilters: (categories, types, offlineOnly) {
          setState(() {
            _selectedCategories = categories;
            _selectedTypes = types;
            _showOfflineOnly = offlineOnly;
          });
        },
      ),
    );
  }

  void _downloadResource(Map<String, dynamic> resource) {
    Fluttertoast.showToast(
      msg: "Downloading ${resource["title"]}...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Simulate download progress
    Future.delayed(const Duration(seconds: 2), () {
      Fluttertoast.showToast(
        msg: "Download completed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  void _shareResource(Map<String, dynamic> resource) {
    Fluttertoast.showToast(
      msg: "Sharing ${resource["title"]}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showEmergencyContacts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Emergency Contacts',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContactTile('Police', '100', 'local_police'),
            _buildContactTile('Fire', '101', 'local_fire_department'),
            _buildContactTile('Ambulance', '102', 'local_hospital'),
            _buildContactTile('Disaster Helpline', '1078', 'emergency'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(String name, String number, String iconName) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.alertLight,
        size: 6.w,
      ),
      title: Text(name),
      subtitle: Text(number),
      trailing: IconButton(
        onPressed: () {
          Fluttertoast.showToast(
            msg: "Calling $number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
        icon: CustomIconWidget(
          iconName: 'phone',
          color: AppTheme.secondaryLight,
          size: 5.w,
        ),
      ),
    );
  }

  void _shareLocation() {
    Fluttertoast.showToast(
      msg: "Sharing your location...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Share Safety Resources',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Share this safety resources library with your family and friends to help them stay prepared for emergencies.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Sharing safety resources app",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}