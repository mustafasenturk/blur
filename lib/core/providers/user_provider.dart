import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final bool isMale;
  final bool isPremium;

  const UserState({
    this.isMale = true,
    this.isPremium = false, // Default to false
  });

  UserState copyWith({bool? isMale, bool? isPremium}) {
    return UserState(
      isMale: isMale ?? this.isMale,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState());

  void setGender(bool isMale) {
    state = state.copyWith(isMale: isMale);
  }

  void setPremium(bool isPremium) {
    state = state.copyWith(isPremium: isPremium);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
