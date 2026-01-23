import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final bool isMale;

  const UserState({this.isMale = true});

  UserState copyWith({bool? isMale}) {
    return UserState(isMale: isMale ?? this.isMale);
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState());

  void setGender(bool isMale) {
    state = state.copyWith(isMale: isMale);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
