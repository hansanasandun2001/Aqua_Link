import 'package:flutter/material.dart';

import '../service_provider/create_adssp.dart';
import '../service_provider/service_history.dart';
import '../service_provider/service_requests.dart';

class service_provider extends StatefulWidget {
  const service_provider({super.key});

  @override
  State<service_provider> createState() => _service_providerState();
}

class _service_providerState extends State<service_provider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Provide')),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
            children: [
            ElevatedButton(
            onPressed: () {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const service_requests()),
      );
      },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00BCD4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.build, size: 36),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Service Requests",
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Access Service Requests Dashboard",
                    style: TextStyle(height: 0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 15),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const service_history()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00BCD4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.history, size: 36),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Service History",
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Access Service History  Dashboard",
                    style: TextStyle(height: 0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const create_adssp()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00BCD4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.ads_click_outlined, size: 36),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create ads",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Access Create ads Dashboard",
                            style: TextStyle(height: 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
        ),
      ),
    );
  }
}