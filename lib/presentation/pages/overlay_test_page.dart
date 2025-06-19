import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/home_header_material3.dart';
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
    final baseColor = Colors.red;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeaderMaterial3(
              hostName: 'TestHostName',
              baseColor: baseColor,
              surfaceTint: Theme.of(context).colorScheme.surfaceTint,
              overlayActive: _showOverlay,
              textColor: Colors.white,
              height: 80,
              actions: [
                IconButton(
                  icon: const Icon(Icons.info, color: Colors.white),
                  onPressed: () {},
                ),
              ],
              textStyle: const TextStyle(fontSize: 22, color: Colors.white),
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
