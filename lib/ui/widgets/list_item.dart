import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  final String id;
  final void Function(String id)? onDismissed;
  final Widget headerContent;
  final Widget? expandedContent;

  const ListItem({
    super.key,
    required this.id,
    this.onDismissed,
    required this.headerContent,
    this.expandedContent,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 14
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.headerContent,
            ClipRect(
              child: AnimatedAlign(
                alignment: Alignment.topCenter,
                heightFactor: _isExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child: widget.expandedContent ?? const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.onDismissed != null) {
      content = Dismissible(
        key: Key(widget.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => widget.onDismissed!(widget.id),
        child: content,
      );
    }

    return content;
  }


}
