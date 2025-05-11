import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ListItem extends StatefulWidget {
  final String id;
  final String title;
  final String secondary_text;
  final void Function(String id) onDelete;
  final void Function() onEdit;
  final Map<String, String>? details;

  const ListItem({
    super.key,
    required this.id,
    required this.title,
    required this.secondary_text,
    required this.onDelete,
    required this.onEdit,
    this.details,
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
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                      Text(
                        widget.secondary_text.toString(),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.50 : 0.0,
                  duration: Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: Icon(Icons.expand_more),
                ),
                PopupMenuButton<String>(
                  onSelected: (String item) {
                    if (item == 'edit') widget.onEdit();
                    if (item == 'delete') widget.onDelete(widget.id);
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: colorScheme.onSurfaceVariant),
                          SizedBox(width: 6),
                          Text('edit_button'.tr()),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.redAccent),
                          SizedBox(width: 6),
                          Text('Delete'), // TODO: localization
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            ClipRect(
              child: AnimatedAlign(
                alignment: Alignment.topCenter,
                heightFactor: _isExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child: widget.details != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 16), // Add a little spacing if needed
                    ...widget.details!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ) : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );

    return content;
  }


}
