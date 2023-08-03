import 'package:lyrics_app/app/constants/message.dart';

class ErrorMessage extends Message {
  static final lyricsFetchFailed = ErrorMessage('Failed to get lyrics. \nPlease try again.');
  static final emptyUrlError = ErrorMessage('Please enter a URL');
  static final enterUrlMessage = ErrorMessage('Enter a lyrics URL and press the button to get lyrics.');
  static final emptyAlbumError = ErrorMessage('Please enter an album information');

  static final saveFailed = ErrorMessage('Failed to save the album. Please try again.');
  static final deleteFailed = ErrorMessage('Failed to delete the album. Please try again.');
  static final updateFailed = ErrorMessage('Failed to update the album. Please try again.');

  ErrorMessage(String text) : super(text);
}
