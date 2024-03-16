import 'package:flutter/material.dart';
import 'package:todolist_app_statemanagement/models/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_app_statemanagement/providers/all_providers.dart';


class TodoListItemWidget  extends ConsumerStatefulWidget {
  const TodoListItemWidget({Key? key})
      : super(key: key);

  @override
  ConsumerState<TodoListItemWidget> createState() => _TodoListItemWidgetState();
}

class _TodoListItemWidgetState extends ConsumerState<TodoListItemWidget>{

late FocusNode _textFocusNode;
late TextEditingController _textController;
bool _hasFocus = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textFocusNode = FocusNode();
    _textController = TextEditingController();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _textFocusNode.dispose();
    _textController.dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    final currentTodoItem = ref.watch(currentTodoProvider);

    return Focus(
      onFocusChange: (isFocused)  {
        if (!isFocused){
          setState(() {
            _hasFocus = false;
          });
        }
        ref.read(todoListProvider.notifier).edit(id: currentTodoItem.id, newDescription: _textController.text);

      },
      child: ListTile(
        onTap: (){
          setState(() {
            _hasFocus = true;
            _textFocusNode.requestFocus();
            _textController.text = currentTodoItem.description;
          });


        },
        leading: Checkbox(
          value: currentTodoItem.completed,
          onChanged: (value) {
            ref.read(todoListProvider.notifier).toggle(currentTodoItem.id);
          },
        ),
        title:_hasFocus ? TextField(focusNode: _textFocusNode,controller: _textController,) : Text(currentTodoItem.description),
      ),
    );
  }
}



