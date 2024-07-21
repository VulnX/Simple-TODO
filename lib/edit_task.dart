import 'package:flutter/material.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage(
      {super.key, required this.onUpdateTask, required this.todo});
  final Function onUpdateTask;
  final dynamic todo;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  bool allowTags = false;
  late TextEditingController _taskController;
  String? _tag;
  @override
  void initState() {
    _taskController = TextEditingController(text: widget.todo['task']);
    if (widget.todo['tag'] != null) {
      allowTags = true;
      _tag = widget.todo['tag'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text('Edit task'),
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
                var taskDetails = widget.todo;
                taskDetails['task'] = _taskController.text;
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
                } else {
                  taskDetails['tag'] = null;
                }
                setState(() {
                  widget.onUpdateTask();
                });
                Navigator.pop(context);
              },
              child: const Text('CONFIRM'),
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
