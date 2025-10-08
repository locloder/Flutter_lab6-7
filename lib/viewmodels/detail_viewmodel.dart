
import 'package:flutter/material.dart';
import 'package:my_personal_app/models/user_profile.dart';
import 'package:my_personal_app/models/repositories/user_profile_repository.dart';

class DetailViewModel extends ChangeNotifier {
  final UserProfileRepository _repository;
  UserProfile? _userProfile;
  
  bool isNewProfile = false;

  DetailViewModel({required UserProfileRepository repository})
      : _repository = repository;

  UserProfile? get userProfile => _userProfile;

  void createEmptyProfile() {
    _userProfile = UserProfile.createEmpty();
    isNewProfile = true;
    notifyListeners();
  }

  void loadProfile(String id, {bool isDuplicating = false}) {
    _userProfile = _repository.getProfileById(id);
    
    if (_userProfile != null && isDuplicating) {
      _userProfile = _userProfile!.copyWith(
        id: 'new_duplicate', 
        name: 'КОПІЯ: ${_userProfile!.name}',
      );
      isNewProfile = true;
    } else {
      isNewProfile = false;
    }
    
    notifyListeners();
  }
  
  void saveProfile({
    required String name,
    required String title,
    required String bio,
    required String email,
    required List<String> skills,
  }) {
    if (_userProfile == null) return;
    
    final updatedProfile = _userProfile!.copyWith(
      name: name,
      title: title,
      bio: bio,
      email: email,
      skills: skills,
    );

    if (isNewProfile || updatedProfile.id == 'new_duplicate') {
      _repository.addProfile(updatedProfile.copyWith(id: '')); 
    } else {
      _repository.updateProfile(updatedProfile);
    }
    
    _userProfile = updatedProfile;
    isNewProfile = false;
    notifyListeners();
  }
}