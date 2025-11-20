enum ScreenType {
  tasks,
  calendar,
  fees,
  other,
}

enum TaskPriority {
  low,
  medium,
  high,
}

// Yeni task durumları: backend'de string olarak tutuluyor (idle,inprogress,later,waiting,done)
enum TaskStatus {
  idle,
  inprogress,
  later,
  waiting,
  done,
}

extension TaskStatusX on TaskStatus {
  String get value => name; // name zaten gerekli string'i veriyor (Dart 2.15+)
  static TaskStatus fromString(String v) {
    return TaskStatus.values.firstWhere(
      (e) => e.name == v,
      orElse: () => TaskStatus.idle,
    );
  }
}
