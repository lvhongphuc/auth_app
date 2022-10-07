const validEmail = 'hello@example.com';
const validPassword = '123456';


Future<bool> validateAuth(String email, String password) async {
  
  await Future.delayed(const Duration(seconds: 2));

  final isEmailValid = email == validEmail;
  final isPasswordValid = password == validPassword;
  return isEmailValid &&  isPasswordValid;
}