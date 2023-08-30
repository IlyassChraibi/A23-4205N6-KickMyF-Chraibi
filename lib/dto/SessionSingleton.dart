class SessionSingleton {


  static final SessionSingleton _singleton = SessionSingleton._internal();
  factory SessionSingleton() => _singleton;
  SessionSingleton._internal();


  static SessionSingleton get shared => _singleton;


  String? username;

}