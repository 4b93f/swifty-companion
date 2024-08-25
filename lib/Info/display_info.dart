import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../bloc/bloc.dart';

class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _info = TextEditingController();


  @override
  Widget build(BuildContext context) {
      return Center(
        child: Form(
          key: _formKey,
          child : Center(
            child: SizedBox(
              width: 400,
              child: Search(info: _info),
            ),
          ),
        )
      );
    }
}

class Search extends StatefulWidget {

  final TextEditingController info;
  Search({required this.info});

  @override
  State<Search> createState() => _SearchState();
}

String response = '';

class _SearchState extends State<Search> {

  void search(BackendBloc bloc) async {
    await bloc.fetchData(widget.info.text).catchError((e) {
      return e;
    });
    setResponse(bloc);
  }

  void setResponse(BackendBloc bloc) {
    setState(() {
      response  = bloc.state;
    });
  }

  @override
  Widget build (BuildContext context) {
    if (response == '') {
      return FindUser(search: search, info: widget.info);
    } else if (response.contains('response failed')) {
      return Text('User not found');
    } else {
      return DisplayInfo();
    }
  }
}

class DisplayInfo extends StatefulWidget {
  @override
  State<DisplayInfo> createState() => _DisplayInfoState();
}

class _DisplayInfoState extends State<DisplayInfo> {

  mapToList(Map<String, dynamic> map) {
    List<String> list = [];
    map.forEach((key, value) {
      list.add('$key: $value');
    });
    return list;
  }

  List<String> skillsToList(Map<String, dynamic> skillsData) {
  List<String> skillsList = [];
  skillsData.forEach((cursus, skills) {
    List<String> cursusSkills = ['Cursus: $cursus'];
    (skills as Map<String, dynamic>).forEach((skill, level) {
      cursusSkills.add('$skill: $level');
    });
    skillsList.add(cursusSkills.join('\n'));
  });
  return skillsList;
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackendBloc, String>(
      builder: (context, state) {

        var data = jsonDecode(state);
        List<String> levels = mapToList(data['cursus']);
        List<String> projects = mapToList(data['project']);
        List<String> skills = skillsToList(data['skill']);

        var title = [
          'Projects',
          for (var item in data['skill'].keys) 'Skills: $item',
        ];

        var all = [
          'Login: ${data['login']}',
          'Email: ${data['email']}',
          'Correction Points: ${data['correction_point']}',
          'Wallet: ${data['wallet']}',
          'Level: ${levels.join(', ')}',
        ];

        var grid = [
          '${projects.join('\n')}',
          for (var item in skills)
            item,
        ];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  for (var item in all) Text(item, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar( // Set to true if you always want the scrollbar to be visible
                child: SingleChildScrollView(
                  child: StaggeredGrid.count(
                    crossAxisCount: 1,
                    children: [
                      for (var i = 0; i < grid.length; i++)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(title[i], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                Text(grid[i], style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FindUser extends StatefulWidget {

  final Function(BackendBloc) search;
  final TextEditingController info;
  FindUser({required this.search, required this.info});
  @override
  State<FindUser> createState() => _FindUserState();
}

class _FindUserState extends State<FindUser> {

  @override
  Widget build(BuildContext context) {
    final backendBloc = BlocProvider.of<BackendBloc>(context);
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
          TextFormField(decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'login', hintText: 'Login'), controller: widget.info), SizedBox(height: 20),            ElevatedButton(
          onPressed: () {
              widget.search(backendBloc);
          },
          child: Text('Search...')
          ),
      ],
    );
  }
}