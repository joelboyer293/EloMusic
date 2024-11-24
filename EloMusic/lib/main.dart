import 'dart:io';
import 'package:elo_music/audio_player.dart';
import 'package:english_words/english_words.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'page_manager.dart';
import 'services/service_locator.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getIt<PageManager>().init();
  }

  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( //This widget contains a ChangeNotifierProvider
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
      case 2:
        page = FilePickerPage();
        break;
      case 3:
        page = PlayerPage();
      case 4:
        page = PerCategoryPage();
      case 5:
        page = SliderPage();
      case 6:
        page = ComparisonPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded( //Give me as much space as possible
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SafeArea(child: page),
            ),
          ),
          BottomNavigationBar(
            backgroundColor: Colors.black,
            fixedColor: Colors.amber,
            unselectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: ('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: ('Favorites'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.file_copy),
                label: ('File Select'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                label: ('Music Player'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.square),
                label: ('Per Category'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: ('Sliders'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sailing),
                label: 'Comparison',
              ),
            ],
            currentIndex: selectedIndex, //kept track of
            onTap: (value) {
              setState(() {
                selectedIndex = value;
                print(selectedIndex);
              });
            },
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

class PerCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //build() ==> called everytime it's changed
    var appState = context.watch<MyAppState>(); //watches the app state, rebuild everytime it changes

    return Center(
      child: ListView(
        children: [
          Text('PerCategoryPage'),
          for (var favorite in appState.favorites)
            ListTile( leading: Text("hey"), title: Text(favorite.asString), ),
        ],
      ),
    );
  }
}

class ComparisonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //build() ==> called everytime it's changed
    var appState = context.watch<MyAppState>(); //watches the app state, rebuild everytime it changes

    return Center(
      child: ListView(
        children: [
          Text('ComparisonPage'),
          for (var favorite in appState.favorites)
            ListTile( leading: Text("hey"), title: Text(favorite.asString), ),
        ],
      ),
    );
  }
}

class SliderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //build() ==> called everytime it's changed
    var appState = context.watch<MyAppState>(); //watches the app state, rebuild everytime it changes

    return Center(
      child: ListView(
        children: [
          Text('SliderPage'),
          for (var favorite in appState.favorites)
            ListTile( leading: Text("hey"), title: Text(favorite.asString), ),
        ],
      ),
    );
  }
}

class PlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //build() ==> called everytime it's changed
    var appState = context.watch<MyAppState>(); //watches the app state, rebuild everytime it changes

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AudioProgressBar(),
          AudioControlButtons()
        ],
       );
  }
}

class FilePickerPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) { //build() ==> called everytime it's changed
    var appState = context.watch<MyAppState>(); //watches the app state, rebuild everytime it changes

    return Center(
      child: ElevatedButton(
        onPressed: () {
          appState.testFile();  // ← This instead of print().
        },
        child: Text('Select Folder'),

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
  Future testFile() async {
    final permissionStatus = await Permission.location.status;

    //if (permissionStatus.isDenied) { return;}

    var filePath = '/storage/emulated/0/Music/test.mp3';


  }
  Future<void> pickAndScanDirectory() async {

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      print('No directory selected.');
      return;
    }

    print('Selected directory: $selectedDirectory');

    // Scan the selected directory
    try {
      final directory = Directory(selectedDirectory);

      if (!directory.existsSync()) {
        print('The selected directory does not exist.');
        return;
      }

      // List files and subdirectories in the selected directory
      final entities = directory.listSync(recursive: false, followLinks: false);

      for (var entity in entities) {
        if (entity is File) {
          print('File: ${entity.path}');
        } else if (entity is Directory) {
          print('Directory: ${entity.path}');
        }
      }
    } catch (e) {
      print('Error scanning directory: $e');
    }
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

