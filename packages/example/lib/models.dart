import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PokemonModel extends Equatable {
  const PokemonModel({
    required this.id,
    required this.svgSprite,
    required this.name,
    required this.isFavourited,
    required this.type,
    required this.attribute,
    required this.stats,
    required this.backgroundColor,
  });

  final int id;
  final String svgSprite;
  final String name;
  final bool isFavourited;
  final String type;
  final PokemonAttributeModel attribute;
  final List<PokemonStatModel> stats;
  final Color backgroundColor;

  @override
  List<Object> get props {
    return [
      id,
      svgSprite,
      name,
      isFavourited,
      type,
      attribute,
      stats,
      backgroundColor,
    ];
  }

  @override
  bool? get stringify => true;
}

class PokemonAttributeModel extends Equatable {
  const PokemonAttributeModel({
    required this.height,
    required this.weight,
    required this.speed,
  });

  final double height;
  final double weight;
  final double speed;

  @override
  List<Object> get props => [height, weight, speed];

  @override
  bool? get stringify => true;
}

class PokemonStatModel extends Equatable {
  const PokemonStatModel({required this.name, required this.stat});

  final String name;
  final num stat;

  const PokemonStatModel.dummy()
      : name = 'hp',
        stat = 50;

  @override
  List<Object?> get props => [name, stat];

  @override
  bool? get stringify => true;
}
