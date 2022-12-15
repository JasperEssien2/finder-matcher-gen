import 'dart:math';

import 'package:example/models.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemStat extends StatelessWidget {
  const ItemStat({super.key, required this.stat});

  final PokemonStatModel stat;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: stat.name,
              style: textStyle.bodyMedium!
                  .copyWith(color: const Color(0xff6B6B6B)),
              children: [
                TextSpan(
                  text: '  ${stat.stat}',
                  style: textStyle.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IgnorePointer(
            ignoring: true,
            child: Slider(
              max: max(100, stat.stat.toDouble()),
              min: 0,
              activeColor: getColor,
              inactiveColor: Colors.grey[300],
              value: stat.stat.toDouble(),
              onChanged: (_) {},
            ),
          )
        ],
      ),
    );
  }

  @MatchDeclaration()
  Color get getColor {
    if (stat.stat <= 30) {
      return Colors.red.shade500;
    } else if (stat.stat <= 70) {
      return Colors.amber.shade500;
    }
    return Colors.green.shade500;
  }
}

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({Key? key}) : super(key: key);

  @MatchDeclaration(defaultValue: 'Mark as favourite')
  String get fabText => 'Mark as favourite';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton.extended(
      key: const ValueKey('favourite-fab'),
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          fabText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      onPressed: () {},
    );
  }
}

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final PokemonModel pokemon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FlexibleSpaceBar(
      background: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 140),
        child: Row(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name,
                    style: textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    pokemon.type,
                    style: textTheme.headlineMedium,
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  Text(
                    '#${pokemon.id.toString()}',
                    style: textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: SvgPicture.network(
                  pokemon.svgSprite,
                  width: 130,
                  height: 125,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PokemonAtrribute extends StatelessWidget {
  const PokemonAtrribute({super.key, required this.atrribute});

  @MatchDeclaration()
  final PokemonAttributeModel atrribute;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWidget(context, 'Height', atrribute.height),
          _buildWidget(context, 'Weight', atrribute.weight),
          _buildWidget(context, 'Speed km/h', atrribute.speed),
        ],
      ),
    );
  }

  Widget _buildWidget(BuildContext context, String caption, num value) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: textStyle.bodySmall,
          ),
          const SizedBox(height: 2),
          Text('$value', style: textStyle.bodyMedium),
        ],
      ),
    );
  }
}
