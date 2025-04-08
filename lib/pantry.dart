import 'package:flutter/material.dart';

class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pantry',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 800),
          child: CarouselView(
            scrollDirection: Axis.vertical,
            itemExtent: 330,
            shrinkExtent: 200,
            padding: const EdgeInsets.all(10.0),
            children: List<Widget>.generate(20, (int index) {
              return ColoredBox(
                color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.8),
                child: const SizedBox.expand(),
              );
            }),
          ),
        ),
      ),
    );
  }
}