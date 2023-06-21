import 'package:lyrics_app/constants/message.dart';

class ErrorMessages extends Message {
  static final failedToGetLyrics = Message('Failed to get lyrics. \nPlease try again.');
  static final urlEmpty = Message('Please enter a URL');
  static final enterLyricsUrlAndPressButton = Message('Enter a lyrics URL and press the button to get lyrics.');
  static final albumEmpty = Message('Please enter an album information');

  ErrorMessages(String text) : super(text);
}
