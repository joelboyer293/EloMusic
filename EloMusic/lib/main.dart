import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { //sets up the app
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( //This widget cotains a ChangeNotifierProvider
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'EloMusic',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(200, 200, 200, 1) ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { //can notify others
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
  var favorites = <WordPair>[]; //only contains word pairs

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }


}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = NewPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }


    return Scaffold(
      body: Row(
        children: [
          SafeArea( //for phone mostly. Navigation not on status bar of phone
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex, //kept track of
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded( //Give me as much space as possible
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //build() ==> called everytime it's changed
    var appState = context.watch<MyAppState>(); //watches the app state, rebuild everytime it changes
    var word = appState.current;
    IconData icon;
    if (appState.favorites.contains(word)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text('A random idea: YOU ARE DUMB'),
            SizedBox(height: 10,),
            BigCard(word: word),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();  // ← This instead of print().
                  },
                  child: Text('Next'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();  // ← This instead of print().
                  },
                  label: Text('Like'),
                  icon: Icon(icon),
                ),

              ],
            ),
          ],
        ),

      );

  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //build() ==> called everytime it's changed
    var appState = context.watch<MyAppState>(); //watches the app state, rebuild everytime it changes

      return Center(
        child: ListView(

          children: [
            Text('Favorites'),
            for (var favorite in appState.favorites)
              ListTile( leading: Text("hey"), title: Text(favorite.asString), ),
          ],
        ),
      );



  }

}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.word,
  });

  final WordPair word;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith( //Automatically selects a good color?
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(word.asLowerCase, style: style, semanticsLabel: word.asCamelCase,),
      ),
    );
  }
}
