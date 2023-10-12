class ToDo {

   final int? id;
   final String title;
   final String desc ;
   int isDone;

   ToDo({
     this.id,
     required this.title,
     required this.desc,
     this.isDone = 0,
});

   ToDo.fromMap(Map<String, dynamic> map):
   id =  map['id'],
   title = map['title'],
   desc = map['desc'],
   isDone = map['isDone'];

   Map<String, Object?> toMap(){
      return {
        'id' : id,
         'title' : title,
         'desc'  : desc,
         'isDone' : isDone
      };
   }
}