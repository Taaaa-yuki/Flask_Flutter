import 'package:lyrics_app/app/constants/message.dart';

class ErrorMessages extends Message {
  static final failedToGetLyrics = ErrorMessages('Failed to get lyrics. \nPlease try again.');
  static final urlEmpty = ErrorMessages('Please enter a URL');
  static final enterLyricsUrlAndPressButton = ErrorMessages('Enter a lyrics URL and press the button to get lyrics.');
  static final albumEmpty = ErrorMessages('Please enter an album information');

  static final saveFailed = ErrorMessages('Failed to save the album.Please try again.');
  static final deleteFailed = ErrorMessages('Failed to delete the album.Please try again.');
  static final updateFailed = ErrorMessages('Failed to update the album.Please try again.');

  ErrorMessages(String text) : super(text);
}
