import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';

class Requisition {
  final String id; //id único
  final Timestamp solvedIn;
  final Timestamp createdAt;
  final String description; //descrição da solicitação
  final String idDepartment;
  final String idProvider;
  final String idSector;
  final String idUserRequested;
  final String nameDepartment;
  final String nameProvider;
  final String nameSector;
  final String nameUserApproved;
  final String nameUserRequested;
  final Timestamp paymentForecastDate;
  final Timestamp purchaseDate;
  final String solvedByName;
  final String solvedById;
  final String status;
  final double value;

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
    this.nameUserApproved,
    this.nameUserRequested,
    this.paymentForecastDate,
    this.purchaseDate,
    this.solvedByName,
    this.solvedById,
    this.status,
    this.value,
  });
}
