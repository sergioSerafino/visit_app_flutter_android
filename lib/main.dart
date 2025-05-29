import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Beispiel für ein MVVM-ViewModel nach Flutter/Dart 3-Prinzipien
class CounterViewModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Dieses Widget ist die Wurzel Ihrer Anwendung.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Dies ist das Theme Ihrer Anwendung.
        //
        // PROBIEREN SIE FOLGENDES: Starten Sie Ihre Anwendung mit "flutter run". Sie sehen,
        // dass die Anwendung eine lila Toolbar hat. Ändern Sie dann, ohne die App zu beenden,
        // die seedColor im colorScheme unten zu Colors.green und führen Sie dann ein "Hot Reload"
        // durch (speichern Sie Ihre Änderungen oder drücken Sie den "Hot Reload"-Button in einer
        // Flutter-unterstützten IDE oder drücken Sie "r", wenn Sie die App über die Kommandozeile
        // gestartet haben).
        //
        // Beachten Sie, dass der Zähler nicht auf Null zurückgesetzt wurde; der Anwendungszustand
        // geht beim Reload nicht verloren. Um den Zustand zurückzusetzen, verwenden Sie stattdessen
        // einen Hot Restart.
        //
        // Das funktioniert auch für Code, nicht nur für Werte: Die meisten Codeänderungen können
        // einfach mit Hot Reload getestet werden.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Dieses Widget ist die Startseite Ihrer Anwendung. Es ist zustandsbehaftet, was bedeutet,
  // dass es ein State-Objekt (unten definiert) hat, das Felder enthält, die beeinflussen,
  // wie es aussieht.

  // Diese Klasse ist die Konfiguration für den State. Sie hält die Werte (in diesem Fall den Titel),
  // die vom Eltern-Widget (hier das App-Widget) bereitgestellt und von der build-Methode des States
  // verwendet werden. Felder in einer Widget-Unterklasse sind immer als "final" markiert.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // MVVM: ViewModel-Instanz
  final CounterViewModel _viewModel = CounterViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // PROBIEREN SIE FOLGENDES: Ändern Sie die Farbe hier auf eine bestimmte Farbe (z. B. Colors.amber)
        // und führen Sie ein Hot Reload durch, um zu sehen, wie sich die Farbe der AppBar ändert, während
        // die anderen Farben gleich bleiben.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Hier übernehmen wir den Wert aus dem MyHomePage-Objekt, das von der App.build-Methode erstellt wurde,
        // und verwenden ihn, um den Titel der AppBar zu setzen.
        title: Text(widget.title),
      ),
      body: Center(
        // Center ist ein Layout-Widget. Es nimmt ein einzelnes Kind und positioniert es
        // in der Mitte des Eltern-Widgets.
        child: AnimatedBuilder(
          animation: _viewModel,
          builder:
              (context, _) => Column(
                // Column ist ebenfalls ein Layout-Widget. Es nimmt eine Liste von Kindern und
                // ordnet sie vertikal an. Standardmäßig passt es sich der Breite seiner Kinder an
                // und versucht, so hoch wie das Eltern-Widget zu sein.
                //
                // Column hat verschiedene Eigenschaften, um zu steuern, wie es sich selbst und seine
                // Kinder positioniert. Hier verwenden wir mainAxisAlignment, um die Kinder vertikal zu
                // zentrieren; die Hauptachse ist hier die Vertikale (die Querachse wäre horizontal).
                //
                // PROBIEREN SIE FOLGENDES: Rufen Sie "Debug Painting" auf (wählen Sie die Aktion "Toggle Debug Paint"
                // in der IDE oder drücken Sie "p" in der Konsole), um das Wireframe für jedes Widget zu sehen.
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '${_viewModel.counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewModel.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // Dieses Komma am Ende macht das Auto-Formatieren für build-Methoden angenehmer.
    );
  }
}
