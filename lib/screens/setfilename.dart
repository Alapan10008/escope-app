String global_filename="";
String global_name="";
String global_age="";
String global_Datetime="";
String global_Year="";
String global_Month="";
String global_Day="";


class Userdata{
  String? filename;
  String? name;
  String? age;
  String? Datetime;
  String? year;
  String? month;
  String? day;
  String? downurl;
  Userdata();
  Map<String,dynamic> toJson() =>{'filename':filename,'name':name,'age':age,'DateTime':DateTime,'year':year,'month':month,'day':day,'downurl':downurl};
  Userdata.fromSnapshot(snapshot)
     : filename=snapshot.data()['filename'],
        name=snapshot.data()['name'],
        age=snapshot.data()['age'],
        Datetime =snapshot.data()['DateTime'],
        year=snapshot.data()['year'],
        month=snapshot.data()['month'],
        day=snapshot.data()['day'],
        downurl=snapshot.data()['downurl'];
}


