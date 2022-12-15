import 'package:equatable/equatable.dart';

class PokemonStatEntity extends Equatable {
  const PokemonStatEntity({required this.name, required this.stat});

  final String name;
  final num stat;

  const PokemonStatEntity.dummy()
      : name = 'hp',
        stat = 50;

  @override
  List<Object?> get props => [name, stat];

  @override
  bool? get stringify => true;

  PokemonStatEntity copyWith({
    String? name,
    num? stat,
  }) {
    return PokemonStatEntity(
      name: name ?? this.name,
      stat: stat ?? this.stat,
    );
  }
}
