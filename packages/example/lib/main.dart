import 'package:example/models.dart';
import 'package:example/widgets.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        sliderTheme: SliderThemeData(
          trackHeight: 4,
          thumbShape: SliderComponentShape.noThumb,
          overlayShape: SliderComponentShape.noThumb,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pokemon = const PokemonModel(
    id: 13,
    svgSprite:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
    name: 'Bulbasaur',
    isFavourited: false,
    type: 'Grass, Poison',
    attribute: PokemonAttributeModel(height: 120, weight: 60, speed: 120),
    stats: [
      PokemonStatModel(name: 'Hp', stat: 54),
      PokemonStatModel(name: 'Attack', stat: 60),
      PokemonStatModel(name: 'Deffense', stat: 25),
      PokemonStatModel(name: 'Special-defense', stat: 75),
    ],
    backgroundColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: pokemon.backgroundColor.withOpacity(.1),
            pinned: false,
            flexibleSpace: DetailAppBar(pokemon: pokemon),
          ),
          SliverToBoxAdapter(
            child: PokemonAtrribute(atrribute: pokemon.attribute),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Base stats',
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: pokemon.stats
                    .map((e) => ItemStat(key: ValueKey(e), stat: e))
                    .toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: const AppFloatingActionButton(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
