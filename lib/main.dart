import 'package:english_words/english_words.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: FluentApp(
        title: 'text_flutter',
        theme: FluentThemeData(),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

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
  var displayMode = PaneDisplayMode.open;
  final selected = List.empty();
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      default:
        throw UnimplementedError("No widget for $selectedIndex");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return NavigationView(
        appBar: NavigationAppBar(
            title: Text("Words"),
            automaticallyImplyLeading: false,
        ),
        pane: NavigationPane(
          selected: selectedIndex,
          onItemPressed: (index) => {
            if (index == selectedIndex)
              {
                if (displayMode == PaneDisplayMode.open)
                  {setState(() => displayMode = PaneDisplayMode.compact)}
                else if (displayMode == PaneDisplayMode.compact)
                  {setState(() => displayMode == PaneDisplayMode.open)}
              }
          },
          onChanged: (value) => setState(() => selectedIndex = value),
          items: [
            PaneItem(
                icon: const Icon(FluentIcons.home),
                title: Text("Home"),
                body: page),
            PaneItem(
                icon: const Icon(FluentIcons.heart),
                title: Text("Like"),
                body: page)
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    final style = ButtonStyle(
        textStyle: WidgetStatePropertyAll(
      FluentTheme.of(context).typography.subtitle,
    ));

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = FluentIcons.heart_fill;
    } else {
      icon = FluentIcons.heart;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: () {
                  appState.toggleFavorite();
                },
                style: style,
                child: Row(children: [
                  Icon(icon, size: 20.0),
                  SizedBox(width: 10),
                  Text("Like")
                ]),
              ),
              // label: Text("Like")),
              SizedBox(width: 10),
              FilledButton(
                onPressed: () {
                  appState.getNext();
                },
                style: style,
                child: Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text("No Favorites yet"),
      );
    }

    return ScaffoldPage.withPadding(
        header: const PageHeader(
          title: Text("Favorites"),
        ),
        content: ListView(
          children: [
            Text(
              'You have '
              '${appState.favorites.length} favorites:',
              style: FluentTheme.of(context).typography.bodyLarge,
            ),
            for (var pair in appState.favorites)
              ListTile(
                leading: Icon(FluentIcons.heart),
                title: Text(pair.asLowerCase),
              )
          ],
        ));
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    return Card(
      backgroundColor: Colors.teal.lightest,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          pair.asLowerCase,
          style: FluentTheme.of(context)
              .typography
              .display
              ?.copyWith(color: Colors.green.darker),
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
