import 'package:flutter/material.dart';
import 'package:to_do_app/constants/colors.dart';
import 'package:to_do_app/constants/db_handler.dart';
import 'package:to_do_app/constants/toast.dart';

import '../model/todo.dart';

class ToDoItem extends StatefulWidget {
  final  tasksList;
  final deleteTask;
  const ToDoItem({
    required this.deleteTask,
    super.key,
    required this.tasksList
  });

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: textColor,
            blurRadius: 2,
            offset: Offset(1, 1)
          )
        ],
        borderRadius: BorderRadius.circular(20),
        color: tdYellow
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Card(
        shadowColor: Colors.transparent,
        elevation: 3,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          onTap: (){
            if(widget.tasksList.isDone == 0){
              widget.tasksList.isDone = 1;
              Toast().show('Completed');
            }
            else{
              widget.tasksList.isDone = 0;
            }
            setState(() {
              print(widget.tasksList.isDone);
            });

          },

          //leading Icon
          leading: Icon(
            (widget.tasksList.isDone == 0)
                ?
            Icons.check_box_outline_blank
                :
                Icons.check_box,
          ),
          //title
          title: Text(
            widget.tasksList.title!,
            style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
                decoration: (widget.tasksList.isDone == 1) ? TextDecoration.lineThrough : TextDecoration.none
                ),
          ),

          //subtitle
            subtitle: Text(
              widget.tasksList.desc,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color(0xffE25E3E),
                decoration: (widget.tasksList.isDone == 1) ? TextDecoration.lineThrough : TextDecoration.none
            ),
            ),

          //trailing
          trailing:
             Container(
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showAlertBox();
                            setState(() {

                            });
                          },
                          iconSize: 20,

                          color: tdYellow,
                        ),
                  ),
                 SizedBox(width: 10,),
                 Container(
                   width: 40,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: IconButton(
                        onPressed: ()async{
                          int id = await widget.tasksList.id;
                             widget.deleteTask(id);

                           var database = await DatabaseHandler.instance.readTask();
                          if(database.isEmpty){
                            DatabaseHandler.instance.setisEmpty(true);
                          }
                          Toast().show('Task deleted❌');
                          setState(() {});

                        },
                        icon: Icon(Icons.delete),
                        iconSize: 20,
                        color: Colors.red,
                      ),
                  )
                ],
            ),
             ),
        ),
      ),
    );
  }

  Future<void> showAlertBox() async{
    String title = widget.tasksList.title;
    String desc = widget.tasksList.desc;
    titleController.text = title;
    descriptionController.text = desc;
    await showDialog(
      useSafeArea: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            backgroundColor: tdYellow.withAlpha(200),
            title: Center(
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ),
            content: Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: textColor,
                              blurRadius: 3,
                              offset: Offset(1, 1),
                              spreadRadius: 0
                          )
                        ],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: TextField(
                      controller: titleController,
                      style: TextStyle(color: tdYellow),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle: TextStyle(color: tdYellow),
                          prefixIcon: Icon(
                            Icons.title,
                            color: tdYellow,
                            size: 20,
                          ),
                          prefixIconConstraints: BoxConstraints(
                              maxHeight: 30,
                              minWidth: 25
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: textColor,
                              blurRadius: 3,
                              offset: Offset(1, 1),
                              spreadRadius: 0
                          )
                        ],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: TextField(
                      controller: descriptionController,
                      style: TextStyle(color: tdYellow),
                      maxLines: 2,
                      decoration: InputDecoration(
                          hintMaxLines: 10,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintText: 'Description',
                          hintStyle: TextStyle(height: 2, color: tdYellow),
                          prefixIcon: Icon(
                            Icons.description,
                            color: tdYellow,
                            size: 20,
                          ),
                          prefixIconConstraints: BoxConstraints(
                              maxHeight: 30,
                              minWidth: 25
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed:(){
                    Navigator.pop(context);
                  } ,
                  child: Text('Cancel', style: TextStyle(color: Colors.red),)
              ),
              TextButton(
                  onPressed: ()async{
                    Map<String, Object?> dataRow = ToDo(
                      id: widget.tasksList.id,
                        title: titleController.text.toString(),
                        desc: descriptionController.text.toString()).toMap();
                    await DatabaseHandler.instance.updateTask(dataRow);
                    Navigator.pop(context);

              },
                  child: Text('Save', style: TextStyle(color: Colors.black),)
              )
            ],
          );
        },
    );
  }


}
