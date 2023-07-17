class UserHomeModel{
  late final String _name;
  late final bool _userCompleted;
  late final int _userClass;
  late final String _mathSubject;
  late final int _mathNumber;
  late final bool _pythonStatus;
  late final String _pythonSubject;
  late final int _pythonNumber;


  UserHomeModel(
    { 
      required String name,
      required bool userCompleted,
      required int userClass,
      required String mathSubject,
      required int mathNumber,
      required bool pythonStatus,
      required String pythonSubject,
      required int pythonNumber,
    }
    ){
      _name = name;
      _userCompleted = userCompleted;
      _userClass = userClass;
      _mathSubject = mathSubject;
      _mathNumber = mathNumber;
      _pythonStatus = pythonStatus;
      _pythonSubject = pythonSubject;
      _pythonNumber = pythonNumber;
    }
  
  String get getName => _name;
  bool get getUserCompleted => _userCompleted;
  int get getUserClass => _userClass;
  String get getMathSubject => _mathSubject == 'Undefined' ? 'Bilinmiyor' : _mathSubject;
  int get getMathNumber => _mathNumber;
  bool get getPythonStatus => _pythonStatus;
  String get getPythonSubject => _pythonSubject == 'Undefined' ? 'Bilinmiyor' : _pythonSubject;
  int get getPythonNumber => _pythonNumber;
}