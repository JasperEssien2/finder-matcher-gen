class TaskModel {
  TaskModel(this.task, this.priority);

  final String task;
  final int priority;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TaskModel &&
      other.task == task &&
      other.priority == priority;
  }

  @override
  int get hashCode => task.hashCode ^ priority.hashCode;
}
