import 'package:lyrics_app/constants/message.dart';

class ErrorMessages extends Message {
  static final failedToGetLyrics = ErrorMessages('Failed to get lyrics. \nPlease try again.');
  static final urlEmpty = ErrorMessages('Please enter a URL');
  static final enterLyricsUrlAndPressButton = ErrorMessages('Enter a lyrics URL and press the button to get lyrics.');
  static final albumEmpty = ErrorMessages('Please enter an album information');

  ErrorMessages(String text) : super(text);
}
