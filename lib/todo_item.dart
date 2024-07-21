import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  final dynamic todo;
  final Function toggleToDoState;
  final Function onToDoDelete;
  final Function onToDoUpdate;
  const ToDoItem(
      {super.key,
      required this.todo,
      required this.toggleToDoState,
      required this.onToDoDelete,
      required this.onToDoUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () {
          toggleToDoState(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        tileColor: const Color.fromRGBO(0x33, 0x33, 0x33, 1),
        leading: Icon(
          todo['done'] == true
              ? Icons.check_box_rounded
              : Icons.check_box_outline_blank_rounded,
          color: (todo['done'] == true) ? Colors.greenAccent : Colors.white70,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo['tag'] != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: (todo['tag'] == 'Urgent')
                      ? Colors.redAccent
                      : (todo['tag'] == 'Medium')
                          ? Colors.orangeAccent[400]
                          : (todo['tag'] == 'Procastinate')
                              ? Colors.greenAccent
                              : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  todo['tag'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            Text(
              todo['task'],
              style: TextStyle(
                  decoration: todo['done'] ? TextDecoration.lineThrough : null),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                onToDoUpdate(todo);
              },
              icon: const Icon(Icons.edit),
              color: Colors.blueAccent,
            ),
            IconButton(
              onPressed: () {
                onToDoDelete(todo['id']);
              },
              icon: const Icon(Icons.delete),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
