import 'package:fluent_ui/fluent_ui.dart';
import 'package:test_flutter/src/rust/api/simple.dart';
import 'package:test_flutter/src/rust/frb_generated.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await RustLib.init();
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
        ));
  }
}

class MyAppState extends ChangeNotifier {
  var currentNum = getNum();

  void addOneDart() {
    addOne();
    currentNum = getNum();
    notifyListeners();
  }

  var liked = getAllLiked();

  void toggleLiked() {
    addLike();
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
          title: Text("Count"),
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
    var currentNum = appState.currentNum;
    final style = ButtonStyle(
        textStyle: WidgetStatePropertyAll(
      FluentTheme.of(context).typography.subtitle,
    ));

    IconData icon;
    if (whetherLike(num: currentNum)) {
      icon = FluentIcons.heart_fill;
    } else {
      icon = FluentIcons.heart;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(num: currentNum),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: () {
                  appState.toggleLiked();
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
                  appState.addOneDart();
                },
                style: style,
                child: Text("+ 1"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int sumALL = 0;

  @override
  Widget build(BuildContext context) {
    var allLiked = getAllLiked();

    if (allLiked.isEmpty) {
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
              '${allLiked.length} favorites:',
              style: FluentTheme.of(context).typography.bodyLarge,
            ),
            for (var num in allLiked)
              ListTile(
                leading: Icon(FluentIcons.heart),
                title: Text("$num"),
              ),
            FilledButton(
              onPressed: () async {
                var s = 0;
                await sumAll(dartCallback: (sum) => s = sum);
                setState(() {
                  sumALL = s;
                });
                print(sumALL);
              },
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                    FluentTheme.of(context).typography.bodyLarge),
              ),
              child: Text("Click to sum them. (may take a while time.)"),
            ),
            SizedBox(
              height: 10,
            ),
            if (sumALL != 0)
              Text(
                "sumAll is $sumALL",
                style: FluentTheme.of(context).typography.bodyLarge,
              )
          ],
        ));
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.num,
  });

  final int num;

  @override
  Widget build(BuildContext context) {
    return Card(
      backgroundColor: Colors.teal.lightest,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          "$num",
          style: FluentTheme.of(context)
              .typography
              .display
              ?.copyWith(color: Colors.green.darker),
        ),
      ),
    );
  }
}
