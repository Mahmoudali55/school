import 'package:equatable/equatable.dart';
import 'package:my_template/features/profile/data/model/profile_model.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final ProfileModel? profile;
  final List<ProfileActivity> activities;
  final List<Achievement> achievements;
  final String? error;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.activities = const [],
    this.achievements = const [],
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    ProfileModel? profile,
    List<ProfileActivity>? activities,
    List<Achievement>? achievements,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      activities: activities ?? this.activities,
      achievements: achievements ?? this.achievements,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, profile, activities, achievements, error];
}
