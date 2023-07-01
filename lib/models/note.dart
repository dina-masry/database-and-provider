class Note{
  late int id;
  late int user_id;
  late String title;
  late String info;
  static const String tableName = 'notes';
  Note();
  Note.fromMap(Map<String ,dynamic>rowMAP){
    id = rowMAP['id'];
    user_id = rowMAP['user_id'];
    title = rowMAP['title'];
    info = rowMAP['info'];
  }

  Map<String ,dynamic> toMap(){
    Map<String ,dynamic> map =<String, Object>{};
    map['id'] = id;
    map['user_id'] = user_id;
    map['title'] = title;
    map['info'] = info;
    return map;
  }
}