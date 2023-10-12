import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/constants/colors.dart';
import 'package:to_do_app/constants/db_handler.dart';
import 'package:to_do_app/constants/toast.dart';

import '../model/todo.dart';

class AddTasks extends StatefulWidget {
  const AddTasks({super.key});

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final titleFocusNode = FocusNode();
  final descFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context, 'loading_data');
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset:true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: tdYellow,
        ),
        body:
            GestureDetector(
              onTap: (){
                titleFocusNode.unfocus();
                descFocusNode.unfocus();
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.246,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    tdYellow,
                                    Colors.transparent
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter
                              ),
                              color: tdYellow,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(150),
                                  bottomRight: Radius.circular(150)
                              )
                          ),
                          child: Center(
                              child: Text('Add Task', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white
                              ),
                              )
                          ),
                        ),
                        SizedBox(height: 50,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: tdYellow,
                                        blurRadius: 0,
                                        spreadRadius: 10
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if(value == null || value.isEmpty){
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if(value != null || value.isNotEmpty){
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  focusNode: titleFocusNode,
                                  controller: titleController,
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
                              SizedBox(height: 30,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: tdYellow,
                                          blurRadius: 0,
                                          offset: Offset(1, 1),
                                          spreadRadius: 10
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if(value == null || value.isEmpty){
                                      return 'Please enter some text';
                                    }
                                  },
                                  onChanged: (value) {
                                    if(value != null || value.isNotEmpty){
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  focusNode: descFocusNode,
                                  controller: descController,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: textColor),
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
                              const SizedBox(height: 50,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shadowColor: textColor,
                                    backgroundColor: tdYellow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    )
                                  ),
                                    onPressed: () async{
                                    if(_formKey.currentState!.validate()){
                                      addTask();
                                      Toast().show('Task added✅');
                                      Navigator.pop(context, 'loading_data');
                                    }

                                    },
                                    child: Text('Add', style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  addTask()async{
    await DatabaseHandler.instance.insertTask(
        ToDo(
            title: titleController.text.toString(),
            desc: descController.text.toString(),
        ));
  }
}
