import 'package:lyrics_app/app/constants/message.dart';

class AppMessages extends Message {
  static final addSuccess = AppMessages('Saved successfully');
  static final deleteSuccess = AppMessages('Deleted successfully');
  static final updateSuccess = AppMessages('Updated successfully');
  static final copyClipBoard = AppMessages('Copied to clipboard');

  AppMessages(String text) : super(text);
}