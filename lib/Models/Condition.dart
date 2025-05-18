class Condition
{
    /*[Attributes]*/
    late int id;
    late String name;

    /*[Constructors]*/
    Condition();

    //JSON serialization
    Condition.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'];

    Map<String, dynamic> toJson() =>
    {
        'id': id,
        'name': name
    };

    /*[Methods]*/
    int get getID{
        return id;
    }

}