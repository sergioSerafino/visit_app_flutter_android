# HowTo: Globalen AppBar-Overlay per Scroll-Event aus Tab steuern (Flutter)

## Ziel
Der Overlay-/Schatteneffekt des globalen AppBar-Headers (z. B. homeHeader) soll sich beim Scrollen einer untergeordneten Seite (z. B. HostsPage als Tab) dynamisch anpassen.

## Vorgehen

1. **Callback-Mechanismus einführen:**
   - Die untergeordnete Seite (z. B. HostsPage) erhält einen optionalen Callback `onScrollChanged` und einen eigenen `ScrollController`.
   - Der Callback wird bei jedem Scroll-Event ausgelöst und meldet, ob gescrollt wurde (Offset > 0).

2. **HomePage anpassen:**
   - Die HomePage übergibt den Callback an die HostsPage.
   - Im Callback wird der Overlay-Status (`_showHeaderOverlay`) gesetzt, aber nur, wenn der entsprechende Tab aktiv ist.
   - Die AppBar (bzw. homeHeader) erhält den Overlay-Status als Prop und passt die Darstellung an.

3. **IndexedStack verwenden:**
   - Die Tabs werden im Body der HomePage als `IndexedStack` eingebunden, damit der State der Seiten erhalten bleibt.

## Beispiel-Code

### HostsPage
```dart
class HostsPage extends ConsumerWidget {
  final void Function(bool)? onScrollChanged;
  const HostsPage({super.key, this.onScrollChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (onScrollChanged != null) {
        onScrollChanged!(_scrollController.hasClients && _scrollController.offset > 0);
      }
    });
    return CustomScrollView(
      controller: _scrollController,
      // ...
    );
  }
}
```

### HomePage
```dart
class _HomePageState extends ConsumerState<HomePage> {
  bool _showHeaderOverlay = false;
  int _selectedIndex = 0;

  void _handleHostsScroll(bool show) {
    if (_selectedIndex == 1 && show != _showHeaderOverlay) {
      setState(() {
        _showHeaderOverlay = show;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: homeHeader(
          // ...
          showOverlay: _showHeaderOverlay,
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PodcastPage(),
          HostsPage(onScrollChanged: _handleHostsScroll),
        ],
      ),
      // ...
    );
  }
}
```

## Hinweise
- Der Overlay-Effekt ist jetzt synchron mit dem Scrollverhalten der jeweiligen Tab-Seite.
- Das Pattern ist für beliebige Tabs/Seiten adaptierbar.
- Die AppBar bleibt global, der Overlay wird nur durch die aktive Seite gesteuert.

---
Letzte Aktualisierung: 19.06.2025
