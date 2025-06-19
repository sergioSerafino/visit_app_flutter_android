import 'package:flutter/material.dart';

class OverlayTestPage extends StatefulWidget {
  final void Function(bool)? onScrollChanged;
  const OverlayTestPage({Key? key, this.onScrollChanged}) : super(key: key);

  @override
  State<OverlayTestPage> createState() => _OverlayTestPageState();
}

class _OverlayTestPageState extends State<OverlayTestPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.onScrollChanged != null) {
      final show = _scrollController.hasClients && _scrollController.offset > 0;
      print(
          '[OverlayTestPage] onScrollChanged: show=$show, offset=${_scrollController.offset}');
      widget.onScrollChanged!(show);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 50,
        itemBuilder: (context, index) => ListTile(
          title: Text('Testeintrag $index'),
        ),
      ),
    );
  }
}
