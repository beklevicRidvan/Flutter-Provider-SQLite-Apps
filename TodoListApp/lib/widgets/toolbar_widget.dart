import 'package:flutter/material.dart';
import 'package:todolist_app_statemanagement/providers/all_providers.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";


class ToolBarWidget extends ConsumerWidget {
  ToolBarWidget({Key? key}) : super(key: key);
  var _currentFilter = TodoListFilter.all;


  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final onCompletedTodoCount = ref.watch(unCompletedTodoCount);

     _currentFilter = ref.watch(todoListFilter);

    Color TextChangeColor(TodoListFilter filt){
      return _currentFilter == filt ? Colors.orange : Colors.black;
    }

    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

         Expanded(
          child: Text(onCompletedTodoCount == 0 ? "Tüm görevler OK":onCompletedTodoCount.toString()+" görev tamamlandı",overflow: TextOverflow.ellipsis,),
        ),
        Tooltip(
          message: 'All Todos',
          child: TextButton(onPressed: () {
            ref.read(todoListFilter.notifier).state = TodoListFilter.all;
          }, child:  Text('All',style: TextStyle( color: TextChangeColor(TodoListFilter.all)),
    )),
        ),
        Tooltip(
          message: 'Only Uncompleted Todos',

          child: TextButton(onPressed: () {
            ref.read(todoListFilter.notifier).state = TodoListFilter.active;

          }, child:  Text('Active',style: TextStyle( color: TextChangeColor(TodoListFilter.active)),),
        ),
    ),
        Tooltip(
          message: 'Only Completed Todos',

          child: TextButton(onPressed: () {
            ref.read(todoListFilter.notifier).state = TodoListFilter.completed;

          }, child:  Text('Completed',style: TextStyle( color: TextChangeColor(TodoListFilter.completed)),),
        ),
        )
      ],
    );
  }
}
