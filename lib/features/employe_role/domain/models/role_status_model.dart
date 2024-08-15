class ModuleModel{
  String module;
  bool status;

  ModuleModel({required this.module, required this.status});

  ModuleModel copyWith(bool value) {
    status = value;
    return this;
  }
}