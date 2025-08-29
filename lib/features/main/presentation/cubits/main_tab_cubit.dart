import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_tab_state.dart';

class MainTabCubit extends Cubit<MainTabState> {
  MainTabCubit() : super(const MainTabState(currentIndex: 0));

  void changeTab(int index) {
    if (index != state.currentIndex) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  void goToHome() => changeTab(0);
  void goToAboutUs() => changeTab(1);
  void goToDoctors() => changeTab(2);
  void goToBranches() => changeTab(3);
  void goToAccount() => changeTab(4);
}
