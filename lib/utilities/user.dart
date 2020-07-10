class User {
  String _userName;
  String _userEmail;
  String _profilePicURL;
  bool newMessage = false;

  void set userName(String username) {
    _userName = username;
  }

  void set userMailid(String userEmail) {
    _userEmail = userEmail;
  }

  void set userProfilePicURL(String profilePicURL) {
    _profilePicURL = profilePicURL;
  }

  String get getuserName {
    return _userName;
  }

  String get getuserEmail {
    return _userEmail;
  }

  String get getuserUrl {
    return _profilePicURL;
  }

  /*void togglenewMessage() {
    newMessage = !newMessage;
  }*/
}
