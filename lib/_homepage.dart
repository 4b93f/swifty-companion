import 'package:flutter/material.dart';
import 'Info/display_info.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;

    page = MyForm();
    return LayoutBuilder(
            builder: (context, constraints) {
              return Scaffold(
                body: Row(
                  children: [
                    SafeArea(
                      child: NavigationRail(
                        extended: constraints.maxWidth >= 2600,
                        destinations: [
                          NavigationRailDestination(
                            icon: Icon(Icons.home),
                            label: Text('Home'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.contacts),
                            label: Text('User'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.settings),
                            label: Text('Settings'),
                          ),
                        ],
                        selectedIndex: selectedIndex,
                        onDestinationSelected: (val) {
                          setState(() {
                            response = '';
                            selectedIndex = val;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: constraints.maxWidth - 80,
                        color: Colors.blue[200],
                        child: page,
                      ),
                    )
                  ],
                ),
              );
            }
          );
        }
  }