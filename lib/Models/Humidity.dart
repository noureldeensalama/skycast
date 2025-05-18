class Humidity
{
    /*[Attributes]*/
    late int amount;
    late String units;

    /*[Constructors]*/
    Humidity();

    //JSON serialization
    Humidity.fromJson(Map<String, dynamic> json):
        amount = json['amount'],
        units = json['units'];

    Map<String, dynamic> toJson() =>
    {
        'amount': amount,
        'units': units
    };

    /*[Methods]*/
}