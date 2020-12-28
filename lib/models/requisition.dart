import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';

class Requisition {
  String id; //id único
  Timestamp solvedIn;
  Timestamp createdAt;
  String description; //descrição da solicitação
  String idDepartment;
  String idProvider;
  String idSector;
  String idUserRequested;
  String nameDepartment;
  String nameProvider;
  String nameSector;
  String nameUserRequested;
  Timestamp paymentForecastDate;
  Timestamp purchaseDate;
  String solvedByName;
  String solvedById;
  String status;
  double value;

  Requisition({
    this.id,
    this.solvedIn,
    this.createdAt,
    this.description,
    this.idDepartment,
    this.idProvider,
    this.idSector,
    this.idUserRequested,
    this.nameDepartment,
    this.nameProvider,
    this.nameSector,
    this.nameUserRequested,
    this.paymentForecastDate,
    this.purchaseDate,
    this.solvedByName,
    this.solvedById,
    this.status,
    this.value,
  });
}
