import 'dart:io';

class ServerConstant {
  static String serverUrl = Platform.isAndroid ? "http://10.0.2.2:8800" : "http://127.0.0.1:8800";
}
