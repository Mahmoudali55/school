import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/profile/data/model/parent_profile_model.dart';
import 'package:my_template/features/profile/data/model/profile_model.dart';
import 'package:my_template/features/profile/data/model/student_profile_model.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final ProfileModel? profile;
  final List<ProfileActivity> activities;
  final List<Achievement> achievements;
  final String? error;
  final StatusState<ParentProfileModel> parentProfileStatus;
  final StatusState<StudentProfileModel> studentProfileStatus;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.activities = const [],
    this.achievements = const [],
    this.error,
    this.parentProfileStatus = const StatusState.initial(),
    this.studentProfileStatus = const StatusState.initial(),
  });

  ProfileState copyWith({
    bool? isLoading,
    ProfileModel? profile,
    List<ProfileActivity>? activities,
    List<Achievement>? achievements,
    String? error,
    StatusState<ParentProfileModel>? parentProfileStatus,
    StatusState<StudentProfileModel>? studentProfileStatus,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      activities: activities ?? this.activities,
      achievements: achievements ?? this.achievements,
      error: error ?? this.error,
      parentProfileStatus: parentProfileStatus ?? this.parentProfileStatus,
      studentProfileStatus: studentProfileStatus ?? this.studentProfileStatus,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    profile,
    activities,
    achievements,
    error,
    parentProfileStatus,
    studentProfileStatus,
  ];
}
