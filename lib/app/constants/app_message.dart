import 'package:lyrics_app/app/constants/base_message.dart';

class AppMessage extends Message {
  static final addSuccess = AppMessage('Saved successfully');
  static final deleteSuccess = AppMessage('Deleted successfully');
  static final updateSuccess = AppMessage('Updated successfully');
  static final copyClipBoard = AppMessage('Copied to clipboard');
  
  AppMessage(String text) : super(text);
}