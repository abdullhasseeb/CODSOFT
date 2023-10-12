import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/constants/colors.dart';
import 'package:to_do_app/constants/db_handler.dart';
import 'package:to_do_app/screens/add_tasks.dart';
import 'package:to_do_app/widgets/todo_item.dart';

import '../model/todo.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _todoController = TextEditingController();
  final searchBarFocusNode = FocusNode();
  String searchKey = '';
  final searchFieldController = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.26,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      tdYellow.withAlpha(101),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
                boxShadow: [
                  BoxShadow(
                    color: tdYellow,
                    blurRadius: 5,
                    spreadRadius: 2
                  )
                ],
                color: tdYellow,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                )
            ),
          ),
          GestureDetector(
            onTap: () {
              searchBarFocusNode.unfocus();
            } ,
            child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                          child: searchField()
                      ),
                      Container(
                        margin : EdgeInsets.only(top:40, bottom: 10),
                        child: Text(
                          'Your Tasks',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MondayRain',
                            shadows: [
                              Shadow(
                                color: tdYellow,
                                blurRadius: 5,
                                offset: Offset(1, 1)
                              )
                            ]
                          ),
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                            onTap: (){

                            },
                            child: Container(
                              child: FutureBuilder(
                                future: searchKey.isEmpty ?
                                           DatabaseHandler.instance.readTask()
                                        :
                                           DatabaseHandler.instance.searchItems(searchKey),
                                builder: (context, AsyncSnapshot<List<ToDo>>snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  else if (snapshot.hasError) {
                                    return Center(
                                        child: Text('Error: ${snapshot.error}')
                                    );
                                  }
                                  else {
                                    var tasks = snapshot.data!;
                                    if (tasks != null && tasks.isNotEmpty) {
                                      var length = snapshot.data!.length;
                                      return ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        itemCount: length,
                                        itemBuilder: (context, index) {
                                          //itemIndex is for reverse the tasks
                                          var itemIndex = length - index - 1;
                                          return ToDoItem(
                                            tasksList: snapshot
                                                .data![itemIndex],
                                            deleteTask: deleteTask,
                                          );
                                        },
                                      );
                                    }
                                    else {
                                      return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Icon(Icons.check_circle_outline,
                                                  size: 100.0,
                                                  color: textColor),
                                              Text(
                                                'No tasks yet',
                                                style: TextStyle(fontSize: 18.0,
                                                    color: textColor),
                                              ),
                                            ],
                                          )
                                      );
                                    }
                                  }
                                }
                              ),
                            ),
                          ),
                      ),

                    ],
                  ),
                ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Text('+', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),),
        backgroundColor: Colors.white,
        onPressed: () async {
          searchBarFocusNode.unfocus();
          String loadingData = await  Navigator.push(context, MaterialPageRoute(builder: (context) => AddTasks()),);
          if(loadingData == 'loading_data'){
           setState(() {
           });
          }
          searchFieldController.clear();
        }

      )
    );
  }

  //delete any Task
  deleteTask(int id){
    setState(() {
      DatabaseHandler.instance.deleteTask(id);
    });
  }

  //search Box UI
  Widget searchField(){
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: textColor,
            blurRadius: 1,
            offset: Offset(1, 1),
            spreadRadius: 0
          )
        ]
      ),
      child: TextField(
        controller: searchFieldController,
        focusNode: searchBarFocusNode,
        onChanged: (value) {
          setState(() {
            searchKey = value.toString();
          });
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdYellow,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(
                maxHeight: 20,
                minWidth: 25
            ),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(
                color: tdYellow
            )
        ),
      ),
    );
  }

  //app bar UI
  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor:Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: tdYellow,
            size: 30,
          ),
          Container(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: tdYellow,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            )
          )
        ],
      ),
    );
  }
}
