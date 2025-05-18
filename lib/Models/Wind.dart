class Wind
{
    /*[Attributes]*/
    late double amount;
    late String units;

    /*[Constructors]*/
    Wind();

    //JSON serialization
    Wind.fromJson(Map<String, dynamic> json):
        amount = json['amount'],
        units = json['units'];

    Map<String, dynamic> toJson() =>
    {
        'amount': amount,
        'units': units
    };

    /*[Methods]*/
}