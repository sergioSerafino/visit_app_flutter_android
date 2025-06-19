import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/simple_section_header.dart';
import '../../application/providers/overlay_header_provider.dart';

class OverlayTestPage extends ConsumerStatefulWidget {
  final void Function(bool)? onScrollChanged;
  const OverlayTestPage({Key? key, this.onScrollChanged}) : super(key: key);

  @override
  ConsumerState<OverlayTestPage> createState() => _OverlayTestPageState();
}

class _OverlayTestPageState extends ConsumerState<OverlayTestPage> {
  late final ScrollController _scrollController;
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final show = _scrollController.hasClients && _scrollController.offset > 0;
    ref.read(overlayHeaderProvider.notifier).setOverlay(show);
    if (widget.onScrollChanged != null) {
      widget.onScrollChanged!(show);
    }
    setState(() {
      _showOverlay = show;
    });
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SimpleSectionHeader(
              title: 'Overlay: ' + (_showOverlay ? 'AKTIV' : 'INAKTIV'),
              showShadow: true,
              color: Colors.red,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('Testeintrag $index'),
              ),
              childCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}
