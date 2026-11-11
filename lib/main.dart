
import 'package:flutter/material.dart';

void main() {
  runApp(const ShinyDemo());
}

class ShinyDemo extends StatefulWidget {
  const ShinyDemo({super.key});

  @override
  State<ShinyDemo> createState() => _ShinyDemoState();
}

class _ShinyDemoState extends State<ShinyDemo> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shiny-lab Flutter Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'buttonClicker',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 24),
              Text(
                '$count',
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    count++;
                    count++;
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('カウント +2'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    count = 0;
                  });
                },
                child: const Text('リセット'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
