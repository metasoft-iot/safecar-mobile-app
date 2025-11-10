abstract class AuthTokenProvider {
  Future<String?> getToken();
}

class StaticTokenProvider implements AuthTokenProvider {
  StaticTokenProvider({required String token}) : _token = token;

  final String _token;

  @override
  Future<String?> getToken() async {
    if (_token.isEmpty) {
      return null;
    }
    return _token;
  }
}
