import 'package:example/item_stats.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class PokemonDetailScreen extends StatefulWidget {
  static String pageName = 'PokemonDetailScreen';

  const PokemonDetailScreen({
    super.key,
    this.pokemon,
  });

  final PokemonEntity? pokemon;

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: pokemon.backgroundColor,
            pinned: false,
            flexibleSpace: DetailAppBar(
              
            ),
          ),
          const SliverToBoxAdapter(
            child: PokemonAtrribute(),
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
                    .map((e) => ItemStats(
                          key: ValueKey(e),
                          stat: e,
                          index: pokemon.stats.indexOf(e),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _dataController,
        builder: (context, _) {
          return const AppFloatingActionButton();
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton.extended(
      key: const ValueKey('favourite-fab'),
      backgroundColor: primaryColor.withOpacity(.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Mark as favourite',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: primaryColor,
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
    required this.pokemonName,
    required this.pokemonId,
    required this.pokemonImage,
    required this.pokemonType,
  }) : super(key: key);

  final String pokemonName;
  final String pokemonId;
  final String pokemonImage;
  final String pokemonType;

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
                    pokemonName,
                    style: textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    pokemonType,
                    style: textTheme.headlineMedium,
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  Text(
                    pokemonId,
                    style: textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.network(
                  pokemonImage,
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
  const PokemonAtrribute({super.key});

  double get height => 120.0;
  double get weight => 60.0;
  double get speed => 120.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWidget(context, 'Height', height),
          _buildWidget(context, 'Weight', weight),
          _buildWidget(context, 'Speed km/h', speed),
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
