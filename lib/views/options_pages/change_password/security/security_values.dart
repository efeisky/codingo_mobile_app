bool checkValues(String initialUsername,String usernameText, String newPass) {
  return initialUsername == usernameText && newPass.isNotEmpty ? true : false;
}