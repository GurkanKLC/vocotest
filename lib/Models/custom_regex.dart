extension CustomRegex on String {

String? isValidEmail() {
  if(this==""){
return "Email girmeniz zorunludur";
  }

  if(RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(this)==false){
    return "Geçersiz mail adresi";
  }

  return null;
}
String? isValidPassword() {
  if(this==""){
    return "Şifre girmeniz zorunludur";
  }
  if(length<6){
    return "Şifre en az 6 karakter olmalıdır";
  }
  if(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*$')
      .hasMatch(this)==false){
    return "Şifre en az bir büyük harf, bir küçük harf ve bir rakam içermelidir.";
  }
  return null;

}



}