class MainTabState {
  final int currentIndex;

  const MainTabState({this.currentIndex = 0});

  MainTabState copyWith({int? currentIndex}) {
    return MainTabState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MainTabState && other.currentIndex == currentIndex;
  }

  @override
  int get hashCode => currentIndex.hashCode;
}
