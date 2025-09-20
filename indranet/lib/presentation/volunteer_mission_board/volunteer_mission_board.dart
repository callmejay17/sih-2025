import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/mission_card_widget.dart';
import './widgets/my_mission_card_widget.dart';

class VolunteerMissionBoard extends StatefulWidget {
  const VolunteerMissionBoard({Key? key}) : super(key: key);

  @override
  State<VolunteerMissionBoard> createState() => _VolunteerMissionBoardState();
}

class _VolunteerMissionBoardState extends State<VolunteerMissionBoard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isRefreshing = false;
  Map<String, dynamic> _currentFilters = {};

  // Mock data for available missions
  final List<Map<String, dynamic>> _availableMissions = [
    {
      "id": 1,
      "type": "rescue",
      "priority": "urgent",
      "location": "Kedarnath Valley, Uttarakhand",
      "distance": "2.3 km",
      "description":
          "Flash flood rescue operation needed. Multiple families trapped in remote villages. Immediate assistance required for evacuation and medical aid.",
      "requiredSkills": ["First Aid", "Search & Rescue", "Communication"],
      "volunteersNeeded": 8,
      "estimatedTime": "6-8 hours",
      "coordinator": "Rajesh Kumar",
      "timestamp": "2025-09-17T05:43:44.538283",
    },
    {
      "id": 2,
      "type": "medical",
      "priority": "high",
      "location": "Cyclone Affected Area, Odisha",
      "distance": "5.7 km",
      "description":
          "Medical camp setup required for cyclone victims. Need volunteers with medical training to assist in primary healthcare delivery.",
      "requiredSkills": ["Medical Training", "First Aid", "Logistics"],
      "volunteersNeeded": 12,
      "estimatedTime": "4-6 hours",
      "coordinator": "Dr. Priya Sharma",
      "timestamp": "2025-09-17T04:43:44.538283",
    },
    {
      "id": 3,
      "type": "supply",
      "priority": "normal",
      "location": "Flood Relief Center, Kerala",
      "distance": "8.2 km",
      "description":
          "Food and essential supplies distribution to flood-affected families. Help needed in organizing and distributing relief materials.",
      "requiredSkills": ["Logistics", "Transportation", "Communication"],
      "volunteersNeeded": 15,
      "estimatedTime": "3-4 hours",
      "coordinator": "Anita Menon",
      "timestamp": "2025-09-17T03:43:44.538283",
    },
    {
      "id": 4,
      "type": "evacuation",
      "priority": "urgent",
      "location": "Landslide Zone, Himachal Pradesh",
      "distance": "12.1 km",
      "description":
          "Emergency evacuation support needed for landslide-affected areas. Assist in safe relocation of residents to temporary shelters.",
      "requiredSkills": ["Search & Rescue", "Transportation", "Heavy Lifting"],
      "volunteersNeeded": 20,
      "estimatedTime": "8-10 hours",
      "coordinator": "Captain Vikram Singh",
      "timestamp": "2025-09-17T02:43:44.538283",
    },
    {
      "id": 5,
      "type": "search",
      "priority": "high",
      "location": "Missing Persons Area, Uttarakhand",
      "distance": "15.3 km",
      "description":
          "Search operation for missing trekkers in mountainous terrain. Experienced volunteers needed for systematic search and rescue.",
      "requiredSkills": [
        "Search & Rescue",
        "Technical Skills",
        "Communication"
      ],
      "volunteersNeeded": 10,
      "estimatedTime": "12+ hours",
      "coordinator": "Suresh Rawat",
      "timestamp": "2025-09-17T01:43:44.538283",
    },
  ];

  // Mock data for user's missions
  final List<Map<String, dynamic>> _myMissions = [
    {
      "id": 101,
      "type": "medical",
      "status": "active",
      "location": "Relief Camp, Chennai",
      "joinedDate": "Yesterday",
      "description":
          "Providing medical assistance to flood victims. Currently stationed at the main relief camp coordinating with medical team.",
      "coordinator": "Dr. Ramesh Kumar",
      "timestamp": "2025-09-16T07:43:44.538283",
    },
    {
      "id": 102,
      "type": "supply",
      "status": "pending",
      "location": "Distribution Center, Mumbai",
      "joinedDate": "2 days ago",
      "description":
          "Awaiting assignment for food distribution drive. Training session scheduled for tomorrow morning.",
      "coordinator": "Meera Patel",
      "timestamp": "2025-09-15T07:43:44.538283",
    },
  ];

  // Mock data for completed missions
  final List<Map<String, dynamic>> _completedMissions = [
    {
      "id": 201,
      "type": "rescue",
      "status": "completed",
      "location": "Flood Area, Assam",
      "completedDate": "Last week",
      "description":
          "Successfully assisted in evacuating 50+ families from flood-affected areas. Provided emergency shelter and basic medical aid.",
      "coordinator": "Ravi Sharma",
      "timestamp": "2025-09-10T07:43:44.538283",
      "impact": "50 families evacuated safely",
    },
    {
      "id": 202,
      "type": "relief",
      "status": "completed",
      "location": "Earthquake Zone, Gujarat",
      "completedDate": "2 weeks ago",
      "description":
          "Participated in relief material distribution and temporary shelter setup for earthquake victims.",
      "coordinator": "Anjali Desai",
      "timestamp": "2025-09-03T07:43:44.538283",
      "impact": "200+ people provided relief",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: Text(
          'Volunteer Missions',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          if (_currentTabIndex == 0)
            IconButton(
              onPressed: _showFilterBottomSheet,
              icon: CustomIconWidget(
                iconName: 'filter_list',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/user-profile-settings'),
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'My Missions'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Near You section header (only for available missions)
          if (_currentTabIndex == 0 && _availableMissions.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'near_me',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Near You',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_getFilteredMissions().length} missions',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableMissionsTab(),
                _buildMyMissionsTab(),
                _buildCompletedMissionsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, '/alert-center'),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: CustomIconWidget(
                iconName: 'emergency',
                color: Colors.white,
                size: 24,
              ),
              label: Text(
                'Emergency Alert',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildAvailableMissionsTab() {
    final filteredMissions = _getFilteredMissions();

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: filteredMissions.isEmpty
          ? EmptyStateWidget(
              title: 'No Missions Available',
              message:
                  'Check back soon for new volunteer opportunities in your area. Enable notifications to get alerted about urgent missions.',
              actionText: 'Enable Notifications',
              onActionPressed: _enableNotifications,
              iconName: 'volunteer_activism',
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: filteredMissions.length,
              itemBuilder: (context, index) {
                final mission = filteredMissions[index];
                return MissionCardWidget(
                  mission: mission,
                  onJoinMission: () => _joinMission(mission),
                  onTap: () => _showMissionDetails(mission),
                );
              },
            ),
    );
  }

  Widget _buildMyMissionsTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: _myMissions.isEmpty
          ? EmptyStateWidget(
              title: 'No Active Missions',
              message:
                  'You haven\'t joined any missions yet. Browse available missions and start making a difference in your community.',
              actionText: 'Browse Missions',
              onActionPressed: () {
                _tabController.animateTo(0);
              },
              iconName: 'assignment',
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _myMissions.length,
              itemBuilder: (context, index) {
                final mission = _myMissions[index];
                return MyMissionCardWidget(
                  mission: mission,
                  onTap: () => _showMissionDetails(mission),
                  onUpdate: () => _updateMissionStatus(mission),
                  onCommunicate: () => _communicateWithTeam(mission),
                );
              },
            ),
    );
  }

  Widget _buildCompletedMissionsTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: _completedMissions.isEmpty
          ? EmptyStateWidget(
              title: 'No Completed Missions',
              message:
                  'Your completed volunteer missions will appear here. Start volunteering to build your impact history.',
              actionText: 'Start Volunteering',
              onActionPressed: () {
                _tabController.animateTo(0);
              },
              iconName: 'check_circle',
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _completedMissions.length,
              itemBuilder: (context, index) {
                final mission = _completedMissions[index];
                return _buildCompletedMissionCard(mission);
              },
            ),
    );
  }

  Widget _buildCompletedMissionCard(Map<String, dynamic> mission) {
    final missionType = mission['type'] as String? ?? 'rescue';
    final location = mission['location'] as String? ?? 'Unknown Location';
    final completedDate = mission['completedDate'] as String? ?? 'Unknown';
    final description = mission['description'] as String? ?? '';
    final impact = mission['impact'] as String? ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'COMPLETED',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: _getMissionTypeIcon(missionType),
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getMissionTypeLabel(missionType),
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location and completed date
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        location,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Completed: $completedDate',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Description
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                if (impact.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'trending_up',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Impact: $impact',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredMissions() {
    List<Map<String, dynamic>> filtered = List.from(_availableMissions);

    // Apply distance filter
    if (_currentFilters['distanceRadius'] != null) {
      final maxDistance = _currentFilters['distanceRadius'] as double;
      filtered = filtered.where((mission) {
        final distanceStr = mission['distance'] as String? ?? '0 km';
        final distance =
            double.tryParse(distanceStr.replaceAll(' km', '')) ?? 0;
        return distance <= maxDistance;
      }).toList();
    }

    // Apply mission type filter
    if (_currentFilters['missionTypes'] != null &&
        (_currentFilters['missionTypes'] as List).isNotEmpty) {
      final selectedTypes = (_currentFilters['missionTypes'] as List)
          .map((type) => type.toString().toLowerCase())
          .toList();
      filtered = filtered.where((mission) {
        final missionType = (mission['type'] as String? ?? '').toLowerCase();
        return selectedTypes.contains(missionType);
      }).toList();
    }

    // Apply skills filter
    if (_currentFilters['skills'] != null &&
        (_currentFilters['skills'] as List).isNotEmpty) {
      final selectedSkills = _currentFilters['skills'] as List;
      filtered = filtered.where((mission) {
        final requiredSkills =
            (mission['requiredSkills'] as List?)?.cast<String>() ?? [];
        return selectedSkills.any((skill) => requiredSkills.contains(skill));
      }).toList();
    }

    return filtered;
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Missions updated successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onApplyFilters: (filters) {
          setState(() {
            _currentFilters = filters;
          });
        },
      ),
    );
  }

  void _joinMission(Map<String, dynamic> mission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Join Mission'),
        content: Text(
            'Are you sure you want to join this mission? You will be contacted by the coordinator with further details.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleJoinMission(mission);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            ),
            child: Text('Join', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleJoinMission(Map<String, dynamic> mission) {
    // Add to my missions with pending status
    final newMission = Map<String, dynamic>.from(mission);
    newMission['status'] = 'pending';
    newMission['joinedDate'] = 'Today';
    _myMissions.insert(0, newMission);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Successfully joined mission! Check "My Missions" tab for updates.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            _tabController.animateTo(1);
          },
        ),
      ),
    );
  }

  void _showMissionDetails(Map<String, dynamic> mission) {
    Navigator.pushNamed(context, '/disaster-detail-modal', arguments: mission);
  }

  void _updateMissionStatus(Map<String, dynamic> mission) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Update Mission Status',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text('Mark as Completed'),
              onTap: () {
                Navigator.pop(context);
                _markMissionCompleted(mission);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'pause_circle',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Report Issue'),
              onTap: () {
                Navigator.pop(context);
                _reportMissionIssue(mission);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _communicateWithTeam(Map<String, dynamic> mission) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening communication channel with mission team...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markMissionCompleted(Map<String, dynamic> mission) {
    // Move to completed missions
    final completedMission = Map<String, dynamic>.from(mission);
    completedMission['status'] = 'completed';
    completedMission['completedDate'] = 'Today';
    completedMission['impact'] = 'Mission completed successfully';

    _completedMissions.insert(0, completedMission);
    _myMissions.removeWhere((m) => m['id'] == mission['id']);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Mission marked as completed! Thank you for your service.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _reportMissionIssue(Map<String, dynamic> mission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please describe the issue you encountered:'),
            SizedBox(height: 2.h),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe the issue...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Issue reported successfully. Our team will investigate.'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Report', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _enableNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enable Notifications'),
        content: Text(
            'Get notified about urgent missions and volunteer opportunities in your area.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Notifications enabled! You\'ll be alerted about new missions.'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            ),
            child: Text('Enable', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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

  String _getMissionTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'rescue':
        return 'Rescue Operation';
      case 'medical':
        return 'Medical Aid';
      case 'supply':
        return 'Supply Distribution';
      case 'evacuation':
        return 'Evacuation Support';
      case 'search':
        return 'Search Operation';
      case 'relief':
        return 'Relief Work';
      default:
        return 'General Mission';
    }
  }
}
