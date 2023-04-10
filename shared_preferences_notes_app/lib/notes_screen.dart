import 'dart:convert';
import 'package:flutter/material.dart';
import 'add_notes.dart';
import 'model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  List<Notes> list =[];
  late SharedPreferences sharedPreferences;

  getData() async{
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? stringList = sharedPreferences.getStringList("list");

    if(stringList != null){
      list = stringList.map((item) => Notes.fromMap(json.decode(item))).toList();
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes"),
      ),
      
      body: list.isEmpty?
          const Center(child: Text("Empty"),):

      ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index){
            return ListTile(
              leading: CircleAvatar(
                child: Text('$index'),
              ),
              title: Text(list[index].title),
              subtitle: Text(list[index].description),

              trailing: IconButton(
                  onPressed: (){
                    setState(() {
                      list.remove(list[index]);
                      List<String> stringList = list.map((item) => json.encode(item.toMap())).toList();
                      sharedPreferences.setStringList("list", stringList);
                    });
                  },
                  icon: const Icon(Icons.delete_forever_outlined)),
            );
          }),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
          onPressed: ()async {
          String refresh = await Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddNotes()));
          if(refresh == "loadData"){
            setState(() {
              getData();
            });
          }
        }),
    );
  }
}
