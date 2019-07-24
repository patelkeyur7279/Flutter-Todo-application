class ModelToDo {
  int id;
  String task;
  int status;

  ModelToDo();
  //ModelToDo(this.task, this.status);

  // Convert a ModelToDo into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'task': task,
      'status': status,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  ModelToDo.fromMap(Map<String, dynamic> data) {
    this.id = data["id"];
    this.task = data["task"];
    this.status = data["status"];
  }
}
