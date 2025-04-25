import 'package:flutter/material.dart';

class DismissibleListItem extends StatelessWidget {
  final String id;
  final void Function(String id)? onDismissed;
  final Widget child;

  const DismissibleListItem({
    super.key,
    required this.id,
    this.onDismissed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );

    if (onDismissed != null) {
      content = Dismissible(
        key: Key(id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDismissed!(id),
        child: content,
      );
    }

    return content;
  }
}
