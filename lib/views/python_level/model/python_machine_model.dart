class PythonMachineModel {
  PythonMachineItems status;
  int? recommendResult;

  PythonMachineModel({
    required this.status,
    this.recommendResult
  });
}

enum PythonMachineItems{
  passed, failed
}