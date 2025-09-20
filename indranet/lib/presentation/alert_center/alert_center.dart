import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/alert_card.dart';
import './widgets/alert_filter_chips.dart';
import './widgets/alert_search_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/near_you_section.dart';

class AlertCenter extends StatefulWidget {
  const AlertCenter({Key? key}) : super(key: key);

  @override
  State<AlertCenter> createState() => _AlertCenterState();
}

class _AlertCenterState extends State<AlertCenter>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _allAlerts = [];
  List<Map<String, dynamic>> _filteredAlerts = [];
  List<Map<String, dynamic>> _nearbyAlerts = [];

  // Mock data for alerts
  final List<Map<String, dynamic>> _mockAlerts = [
    {
      "id": 1,
      "type": "Earthquake",
      "severity": "Severe",
      "headline": "Magnitude 6.2 Earthquake Strikes Northern India",
      "location": "Uttarakhand, India",
      "timestamp": DateTime.now().subtract(Duration(minutes: 15)),
      "description":
          "A strong earthquake of magnitude 6.2 has been recorded in the northern regions of Uttarakhand. Residents are advised to stay away from buildings and move to open areas immediately.",
      "isUnread": true,
      "isNearby": true,
      "affectedAreas": ["Dehradun", "Haridwar", "Rishikesh"],
      "safetyRecommendations": [
        "Move to open areas immediately",
        "Stay away from tall buildings and structures",
        "Keep emergency supplies ready"
      ]
    },
    {
      "id": 2,
      "type": "Flood",
      "severity": "Moderate",
      "headline": "Heavy Rainfall Causes Flooding in Mumbai Suburbs",
      "location": "Mumbai, Maharashtra",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "description":
          "Continuous heavy rainfall has led to waterlogging in several areas of Mumbai. Local authorities have issued advisories for residents in low-lying areas.",
      "isUnread": true,
      "isNearby": false,
      "affectedAreas": ["Andheri", "Kurla", "Sion"],
      "safetyRecommendations": [
        "Avoid traveling unless absolutely necessary",
        "Stay indoors and avoid waterlogged areas",
        "Keep emergency contacts handy"
      ]
    },
    {
      "id": 3,
      "type": "Cyclone",
      "severity": "Severe",
      "headline": "Cyclone Biparjoy Approaching Gujarat Coast",
      "location": "Gujarat, India",
      "timestamp": DateTime.now().subtract(Duration(hours: 4)),
      "description":
          "Cyclone Biparjoy is expected to make landfall near Gujarat coast within the next 24 hours. Wind speeds may reach up to 120 km/h.",
      "isUnread": false,
      "isNearby": false,
      "affectedAreas": ["Kutch", "Jamnagar", "Porbandar"],
      "safetyRecommendations": [
        "Evacuate coastal areas immediately",
        "Secure loose objects and board up windows",
        "Stock up on essential supplies"
      ]
    },
    {
      "id": 4,
      "type": "Fire",
      "severity": "Local",
      "headline": "Forest Fire Reported in Himachal Pradesh",
      "location": "Shimla, Himachal Pradesh",
      "timestamp": DateTime.now().subtract(Duration(hours: 6)),
      "description":
          "A forest fire has been reported in the hills near Shimla. Fire department teams are working to contain the blaze.",
      "isUnread": false,
      "isNearby": true,
      "affectedAreas": ["Shimla Hills", "Kufri"],
      "safetyRecommendations": [
        "Avoid the affected forest areas",
        "Report any new fire sightings immediately",
        "Keep windows closed to avoid smoke"
      ]
    },
    {
      "id": 5,
      "type": "Landslide",
      "severity": "Moderate",
      "headline": "Landslide Blocks Highway in Kerala",
      "location": "Idukki, Kerala",
      "timestamp": DateTime.now().subtract(Duration(hours: 8)),
      "description":
          "Heavy rains have triggered a landslide that has blocked the main highway connecting Idukki to other districts.",
      "isUnread": false,
      "isNearby": false,
      "affectedAreas": ["Idukki", "Munnar Road"],
      "safetyRecommendations": [
        "Use alternative routes for travel",
        "Avoid hillside areas during heavy rain",
        "Stay updated on road conditions"
      ]
    },
    {
      "id": 6,
      "type": "Earthquake",
      "severity": "Local",
      "headline": "Minor Earthquake Felt in Delhi NCR",
      "location": "New Delhi, India",
      "timestamp": DateTime.now().subtract(Duration(hours: 12)),
      "description":
          "A minor earthquake of magnitude 3.8 was felt across Delhi NCR region. No damage has been reported so far.",
      "isUnread": false,
      "isNearby": true,
      "affectedAreas": ["Delhi", "Gurgaon", "Noida"],
      "safetyRecommendations": [
        "Check for any structural damage",
        "Be prepared for possible aftershocks",
        "Keep emergency kit ready"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAlerts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeAlerts() {
    setState(() {
      _allAlerts = List.from(_mockAlerts);
      _nearbyAlerts =
          _allAlerts.where((alert) => alert['isNearby'] == true).toList();
      _applyFilters();
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredAlerts = _allAlerts.where((alert) {
        // Apply search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            (alert['headline'] as String).toLowerCase().contains(searchQuery) ||
            (alert['location'] as String).toLowerCase().contains(searchQuery) ||
            (alert['type'] as String).toLowerCase().contains(searchQuery);

        // Apply severity filter
        final matchesFilter = _selectedFilter == 'All' ||
            (alert['severity'] as String).toLowerCase() ==
                _selectedFilter.toLowerCase();

        return matchesSearch && matchesFilter;
      }).toList();

      // Sort by timestamp (newest first) and unread status
      _filteredAlerts.sort((a, b) {
        final aUnread = a['isUnread'] as bool? ?? false;
        final bUnread = b['isUnread'] as bool? ?? false;

        if (aUnread && !bUnread) return -1;
        if (!aUnread && bUnread) return 1;

        final aTime = a['timestamp'] as DateTime;
        final bTime = b['timestamp'] as DateTime;
        return bTime.compareTo(aTime);
      });
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network refresh
    await Future.delayed(Duration(seconds: 2));

    // Add a new mock alert to simulate real-time updates
    final newAlert = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "type": "Weather",
      "severity": "Moderate",
      "headline": "Heavy Rainfall Warning Issued",
      "location": "Current Location",
      "timestamp": DateTime.now(),
      "description":
          "Meteorological department has issued a heavy rainfall warning for the next 24 hours.",
      "isUnread": true,
      "isNearby": true,
      "affectedAreas": ["Local Area"],
      "safetyRecommendations": [
        "Carry umbrella when going out",
        "Avoid waterlogged areas",
        "Drive carefully on wet roads"
      ]
    };

    setState(() {
      _allAlerts.insert(0, newAlert);
      _nearbyAlerts =
          _allAlerts.where((alert) => alert['isNearby'] == true).toList();
      _isRefreshing = false;
    });

    _applyFilters();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _applyFilters();
  }

  void _onSearchClear() {
    _searchController.clear();
    _applyFilters();
  }

  void _onAlertTap(Map<String, dynamic> alert) {
    // Mark as read
    setState(() {
      alert['isUnread'] = false;
    });

    // Navigate to disaster detail modal
    Navigator.pushNamed(
      context,
      '/disaster-detail-modal',
      arguments: alert,
    );
  }

  void _onSwipeAction(String action, Map<String, dynamic> alert) {
    switch (action) {
      case 'mark_read':
        setState(() {
          alert['isUnread'] = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alert marked as read'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'share':
        // Implement share functionality
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alert shared successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  Widget _buildStickyHeader() {
    return Container(
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Column(
        children: [
          AlertSearchBar(
            controller: _searchController,
            onChanged: (value) => _onSearchChanged(),
            onClear: _onSearchClear,
          ),
          AlertFilterChips(
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList() {
    if (_filteredAlerts.isEmpty && _nearbyAlerts.isEmpty) {
      return EmptyStateWidget();
    }

    return ListView(
      children: [
        // Near You Section
        NearYouSection(
          nearbyAlerts: _nearbyAlerts.where((alert) {
            final searchQuery = _searchController.text.toLowerCase();
            final matchesSearch = searchQuery.isEmpty ||
                (alert['headline'] as String)
                    .toLowerCase()
                    .contains(searchQuery) ||
                (alert['location'] as String)
                    .toLowerCase()
                    .contains(searchQuery) ||
                (alert['type'] as String).toLowerCase().contains(searchQuery);

            final matchesFilter = _selectedFilter == 'All' ||
                (alert['severity'] as String).toLowerCase() ==
                    _selectedFilter.toLowerCase();

            return matchesSearch && matchesFilter;
          }).toList(),
          onAlertTap: _onAlertTap,
          onSwipeAction: _onSwipeAction,
        ),

        // All Alerts Section
        if (_filteredAlerts.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Text(
              'All Alerts',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _filteredAlerts.length,
            itemBuilder: (context, index) {
              final alert = _filteredAlerts[index];
              return AlertCard(
                alert: alert,
                onTap: () => _onAlertTap(alert),
                onSwipeAction: (action) => _onSwipeAction(action, alert),
              );
            },
          ),
        ],
        SizedBox(height: 10.h), // Bottom padding for navigation
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Alert Center',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        actions: [
          IconButton(
            onPressed: _onRefresh,
            icon: _isRefreshing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.appBarTheme.iconTheme?.color ??
                        AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/user-profile-settings');
            },
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.appBarTheme.iconTheme?.color ??
                  AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStickyHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: _buildAlertsList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Alert Center tab is active
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/authentication-screen');
              break;
            case 1:
              // Current screen - Alert Center
              break;
            case 2:
              Navigator.pushReplacementNamed(
                  context, '/volunteer-mission-board');
              break;
            case 3:
              Navigator.pushReplacementNamed(
                  context, '/safety-resources-library');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.bottomNavigationBarTheme
                      .unselectedItemColor ??
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor ??
                  AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'volunteer_activism',
              color: AppTheme.lightTheme.bottomNavigationBarTheme
                      .unselectedItemColor ??
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Volunteer',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'menu_book',
              color: AppTheme.lightTheme.bottomNavigationBarTheme
                      .unselectedItemColor ??
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Resources',
          ),
        ],
      ),
    );
  }
}
