import 'package:flutter/foundation.dart';

class Provider {
  String id;
  String fantasyName;
  String email;
  String address;
  String city;
  String uf;

  Provider({
    this.id,
    @required this.fantasyName,
    @required this.email,
    this.address,
    this.city,
    this.uf,
  });
}
