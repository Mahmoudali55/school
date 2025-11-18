class EndPoints {
  static const String login = 'user/login';
  static const String users = 'users';
  static String detailsUser(int id) => '$users/$id';
}
