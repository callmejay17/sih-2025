import 'package:flutter/material.dart';
import '../presentation/safety_resources_library/safety_resources_library.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/volunteer_mission_board/volunteer_mission_board.dart';
import '../presentation/disaster_detail_modal/disaster_detail_modal.dart';
import '../presentation/alert_center/alert_center.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String safetyResourcesLibrary = '/safety-resources-library';
  static const String authentication = '/authentication-screen';
  static const String userProfileSettings = '/user-profile-settings';
  static const String volunteerMissionBoard = '/volunteer-mission-board';
  static const String disasterDetailModal = '/disaster-detail-modal';
  static const String alertCenter = '/alert-center';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SafetyResourcesLibrary(),
    safetyResourcesLibrary: (context) => const SafetyResourcesLibrary(),
    authentication: (context) => const AuthenticationScreen(),
    userProfileSettings: (context) => const UserProfileSettings(),
    volunteerMissionBoard: (context) => const VolunteerMissionBoard(),
    disasterDetailModal: (context) => const DisasterDetailModal(),
    alertCenter: (context) => const AlertCenter(),
    // TODO: Add your other routes here
  };
}
