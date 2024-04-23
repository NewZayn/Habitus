class User {
  final int id;
  final String nome;
  final String email;

  User({
    required this.id,
    required this.nome,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
    );
  }

  // Métodos
  @override
  String toString() {
    return 'User(id: $id, nome: $nome, email: $email)';
  }
}
