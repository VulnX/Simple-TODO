import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.onUpdateTask});
  final Function onUpdateTask;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  bool allowTags = false;
  final TextEditingController _taskController = TextEditingController();
  String? _tag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text('Add a new task'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: ListView(
          children: [
            taskInputField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add tags for this task?'),
                Switch(
                  value: allowTags,
                  onChanged: (bool value) {
                    setState(() {
                      allowTags = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.blueAccent,
                ),
              ],
            ),
            if (allowTags) tagSection(),
            ElevatedButton(
              onPressed: () {
                var taskDetails = {
                  'task': _taskController.text,
                  'tag': null,
                };
                if (allowTags) {
                  if (_tag != null) {
                    taskDetails['tag'] = _tag!;
                  } else {
                    _showAlert(
                      context,
                      'Oops',
                      'You forgot to choose a tag for this task',
                    );
                    return;
                  }
                }
                widget.onUpdateTask(taskDetails);
                Navigator.pop(context);
              },
              child: const Text('ADD TASK'),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showAlert(
      BuildContext context, String title, String content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  Column tagSection() => Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tag'),
              DropdownButton<String>(
                value: _tag,
                items: <String>['Urgent', 'Medium', 'Procastinate', 'Daily']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(value),
                    ),
                  );
                }).toList(),
                onChanged: (String? tag) {
                  setState(() {
                    _tag = tag;
                  });
                },
              ),
            ],
          ),
          const Divider(),
        ],
      );

  Container taskInputField() => Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0x33, 0x33, 0x33, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _taskController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Type task here...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          autofocus: true,
        ),
      );
}
