class SigninResponse {
  String username = "";    // username dans un format propre produit par le serveur

  SigninResponse.fromJson(Map<String, dynamic> json)
      : username = json['username'];

  SigninResponse(this.username);

  Map<String, dynamic> toJson() => {
    'username': username
  };
}