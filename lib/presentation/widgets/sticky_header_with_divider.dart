import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

/// StickyHeaderWithDivider
///
/// Zeigt einen Divider, solange der Header nicht sticky ist. Sobald der Header sticky wird,
/// blendet sich der Divider aus. Der Header erhält Material mit elevation, wenn sticky.
class StickyHeaderWithDivider extends StatefulWidget {
  final Widget header;
  final Widget content;
  final Color dividerColor;
  final double dividerThickness;
  final double dividerHeight;
  final ScrollController? scrollController;

  const StickyHeaderWithDivider({
    Key? key,
    required this.header,
    required this.content,
    this.dividerColor = Colors.grey,
    this.dividerThickness = 1.0,
    this.dividerHeight = 1.0,
    this.scrollController,
  }) : super(key: key);

  @override
  State<StickyHeaderWithDivider> createState() =>
      _StickyHeaderWithDividerState();
}

class _StickyHeaderWithDividerState extends State<StickyHeaderWithDivider> {
  bool _isSticky = false;
  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_checkSticky);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_checkSticky);
    super.dispose();
  }

  void _checkSticky() {
    final renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final isSticky =
          position.dy <= (MediaQuery.of(context).padding.top + kToolbarHeight);
      if (_isSticky != isSticky) {
        setState(() {
          _isSticky = isSticky;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: _isSticky ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Divider(
            color: widget.dividerColor,
            thickness: widget.dividerThickness,
            height: widget.dividerHeight,
          ),
        ),
        StickyHeader(
          header: Material(
            key: _headerKey,
            elevation: _isSticky ? 2 : 0,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: widget.header,
          ),
          content: widget.content,
        ),
      ],
    );
  }
}
