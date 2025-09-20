import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/disaster_content_widget.dart';
import './widgets/disaster_header_widget.dart';
import './widgets/emergency_contacts_widget.dart';
import './widgets/location_info_widget.dart';
import './widgets/related_resources_widget.dart';

class DisasterDetailModal extends StatefulWidget {
  const DisasterDetailModal({Key? key}) : super(key: key);

  @override
  State<DisasterDetailModal> createState() => _DisasterDetailModalState();
}

class _DisasterDetailModalState extends State<DisasterDetailModal>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Mock disaster data - in real app, this would come from arguments or API
  final Map<String, dynamic> disasterData = {
    "id": 1,
    "type": "Earthquake",
    "severity": "High",
    "timestamp": DateTime.now().subtract(Duration(hours: 3)),
    "location": {
      "area": "Sector 15, Chandigarh",
      "district": "Chandigarh",
      "state": "Punjab",
      "latitude": 30.7333,
      "longitude": 76.7794
    },
    "status":
        "A magnitude 6.2 earthquake struck the region at 4:30 AM. Aftershocks are expected to continue for the next 24-48 hours. Emergency services are actively responding. Several buildings have reported structural damage. Residents are advised to stay in open areas and avoid damaged structures.",
    "affectedPopulation": "~8,500",
    "evacuated": "~2,100"
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background scrim with fade animation
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return GestureDetector(
                onTap: _dismissModal,
                child: Container(
                  color: Colors.black.withValues(alpha: _fadeAnimation.value),
                ),
              );
            },
          ),

          // Modal content with slide animation
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimation,
                child: _buildModalContent(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModalContent() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 85.h, // 85% of screen height
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildDragHandle(),
            Expanded(
              child: _buildScrollableContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return GestureDetector(
      onTap: _dismissModal,
      onPanUpdate: (details) {
        // Handle drag to dismiss
        if (details.delta.dy > 0) {
          _dismissModal();
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Center(
          child: Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Disaster Header
          DisasterHeaderWidget(disasterData: disasterData),

          // Location Information
          LocationInfoWidget(disasterData: disasterData),

          // Main Content
          DisasterContentWidget(disasterData: disasterData),

          // Action Buttons
          ActionButtonsWidget(disasterData: disasterData),

          // Emergency Contacts
          EmergencyContactsWidget(disasterData: disasterData),

          // Related Resources
          RelatedResourcesWidget(disasterData: disasterData),

          // Bottom padding for safe area
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  void _dismissModal() {
    _slideController.reverse().then((_) {
      _fadeController.reverse().then((_) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    });
  }
}
