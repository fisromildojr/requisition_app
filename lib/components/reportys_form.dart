import 'package:requisition_app/components/category_list.dart';
import 'package:requisition_app/components/departments_list_requisition.dart';
import 'package:requisition_app/components/provider_list.dart';
import 'package:requisition_app/components/sector_list_requisition.dart';
import 'package:requisition_app/models/auth_data.dart';
import 'package:requisition_app/models/category.dart';
import 'package:requisition_app/models/department.dart';
import 'package:requisition_app/models/filter_reports.dart';
import 'package:requisition_app/models/provider.dart';
import 'package:requisition_app/models/sector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsForm extends StatefulWidget {
  final void Function(dynamic) onSubmit;

  ReportsForm(this.onSubmit);

  @override
  _ReportsFormState createState() => _ReportsFormState();
}

class _ReportsFormState extends State<ReportsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _initialDateController = TextEditingController();
  final _finalDateController = TextEditingController();

  final _fantasyNameProviderController = TextEditingController();
  final _nameDepartmentController = TextEditingController();
  final _nameSectorController = TextEditingController();
  final _nameCategoryController = TextEditingController();

  Provider selectedProvider;
  Department selectedDepartment;
  Sector selectedSector;
  Category selectedCategory;

  DateTime _selectedInitialDate;
  DateTime _selectedFinalDate;

  _showInitialDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime(2021),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        this._selectedInitialDate = pickedDate;
        _initialDateController.text =
            DateFormat('dd/MM/y').format(_selectedInitialDate);
      });
    });
  }

  _showFinalDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        this._selectedFinalDate = pickedDate;
        _finalDateController.text =
            DateFormat('dd/MM/y').format(_selectedFinalDate);
      });
    });
  }

  _openProviderListModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ProviderList(_selectedProvider);
      },
    );
  }

  _openDepartmentListModal(context) {
    final user = AuthData(
      isAdmin: true,
    );
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return DepartmentListRequisition(_selectedDepartment, user);
      },
    );
  }

  _openSectorListModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SectorListRequisition(_selectedSector, this.selectedDepartment);
      },
    );
  }

  _openCategoryListModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return CategoryList(_selectedCategory);
      },
    );
  }

  _selectedProvider(Provider provider) {
    Navigator.of(context).pop();
    setState(() {
      this.selectedProvider = provider;
      _fantasyNameProviderController.text = provider.fantasyName;
    });
  }

  _selectedDepartment(Department department) {
    Navigator.of(context).pop();
    setState(() {
      this.selectedDepartment = department;
      _nameDepartmentController.text = department.name;
      _nameSectorController.clear();
    });
  }

  _selectedSector(Sector sector) {
    Navigator.of(context).pop();
    setState(() {
      this.selectedSector = sector;
      _nameSectorController.text = sector.name;
    });
  }

  _selectedCategory(Category category) {
    Navigator.of(context).pop();
    setState(() {
      this.selectedCategory = category;
      _nameCategoryController.text = category.name;
    });
  }

  _submitForm() {
    bool isValid = _formKey.currentState.validate();

    if (isValid) {
      final filterReports = FilterReports(
        category: selectedCategory,
        provider: selectedProvider,
        department: selectedDepartment,
        finalDate: _selectedFinalDate,
        initialDate: _selectedInitialDate,
        sector: selectedSector,
      );

      // if (provider.fantasyName.trim().isEmpty ||
      //     provider.email.trim().isEmpty) {
      //   return;
      // }

// Filtro por todos os campos
      if (filterReports.department != null &&
          filterReports.sector != null &&
          filterReports.provider != null &&
          filterReports.category != null) {
        print(filterReports.initialDate);
        print(filterReports.finalDate);
        print(filterReports.department.name);
        print(filterReports.sector.name);
        print(filterReports.provider.fantasyName);
        print(filterReports.category.name);
        Future futureFilter = FirebaseFirestore.instance
            .collection('requisitions')
            .where('createdAt', isGreaterThanOrEqualTo: _selectedInitialDate)
            .where('createdAt', isLessThanOrEqualTo: _selectedFinalDate)
            .where('idDepartment', isEqualTo: filterReports.department.id)
            .where('idSector', isEqualTo: filterReports.sector.id)
            .where('idProvider', isEqualTo: filterReports.provider.id)
            .where('idCategory', isEqualTo: filterReports.category.id)
            .where('status', isEqualTo: 'APROVADO')
            .orderBy('createdAt', descending: true)
            .get();

        widget.onSubmit(futureFilter);
      }

      // Filtro só por data
      if (filterReports.initialDate != null &&
          filterReports.finalDate != null &&
          filterReports.department == null &&
          filterReports.sector == null &&
          filterReports.provider == null &&
          filterReports.category == null) {
        print(filterReports.initialDate);
        print(filterReports.finalDate);

        Future futureFilter = FirebaseFirestore.instance
            .collection('requisitions')
            .where('createdAt', isGreaterThanOrEqualTo: _selectedInitialDate)
            .where('createdAt', isLessThanOrEqualTo: _selectedFinalDate)
            .where('status', isEqualTo: 'APROVADO')
            .orderBy('createdAt', descending: true)
            .get();

        widget.onSubmit(futureFilter);
      }

// Filtro por departamento
      if (filterReports.department != null &&
          filterReports.sector == null &&
          filterReports.provider == null &&
          filterReports.category == null) {
        print(filterReports.initialDate);
        print(filterReports.finalDate);
        print(filterReports.department.name);

        Future futureFilter = FirebaseFirestore.instance
            .collection('requisitions')
            .where('createdAt', isGreaterThanOrEqualTo: _selectedInitialDate)
            .where('createdAt', isLessThanOrEqualTo: _selectedFinalDate)
            .where('idDepartment', isEqualTo: filterReports.department.id)
            .where('status', isEqualTo: 'APROVADO')
            .orderBy('createdAt', descending: true)
            .get();

        widget.onSubmit(futureFilter);
      }

// Filtro por departamento e centro de custo
      if (filterReports.department != null &&
          filterReports.sector != null &&
          filterReports.provider == null &&
          filterReports.category == null) {
        print(filterReports.initialDate);
        print(filterReports.finalDate);
        print(filterReports.department.name);
        print(filterReports.sector.name);

        Future futureFilter = FirebaseFirestore.instance
            .collection('requisitions')
            .where('createdAt', isGreaterThanOrEqualTo: _selectedInitialDate)
            .where('createdAt', isLessThanOrEqualTo: _selectedFinalDate)
            .where('idDepartment', isEqualTo: filterReports.department.id)
            .where('idSector', isEqualTo: filterReports.sector.id)
            .where('status', isEqualTo: 'APROVADO')
            .orderBy('createdAt', descending: true)
            .get();

        widget.onSubmit(futureFilter);
      }

// Filtro por fornecedor
      if (filterReports.department == null &&
          filterReports.sector == null &&
          filterReports.provider != null &&
          filterReports.category == null) {
        print(filterReports.initialDate);
        print(filterReports.finalDate);
        print(filterReports.provider.fantasyName);

        Future futureFilter = FirebaseFirestore.instance
            .collection('requisitions')
            .where('createdAt', isGreaterThanOrEqualTo: _selectedInitialDate)
            .where('createdAt', isLessThanOrEqualTo: _selectedFinalDate)
            .where('idProvider', isEqualTo: filterReports.provider.id)
            .where('status', isEqualTo: 'APROVADO')
            .orderBy('createdAt', descending: true)
            .get();

        widget.onSubmit(futureFilter);
      }

// Filtro por departamento e fornecedor
      if (filterReports.department != null &&
          filterReports.sector == null &&
          filterReports.provider != null &&
          filterReports.category == null) {
        print(filterReports.initialDate);
        print(filterReports.finalDate);
        print(filterReports.department.name);
        print(filterReports.provider.fantasyName);

        Future futureFilter = FirebaseFirestore.instance
            .collection('requisitions')
            .where('createdAt', isGreaterThanOrEqualTo: _selectedInitialDate)
            .where('createdAt', isLessThanOrEqualTo: _selectedFinalDate)
            .where('idDepartment', isEqualTo: filterReports.department.id)
            .where('idProvider', isEqualTo: filterReports.provider.id)
            .where('status', isEqualTo: 'APROVADO')
            .orderBy('createdAt', descending: true)
            .get();

        widget.onSubmit(futureFilter);
      }

// Filtro por categoria
      if (filterReports.department == null &&
          filterReports.sector == null &&
          filterReports.provider == null &&
          filterReports.category != null) {
        print(filterReports.initialDate);
        print(filterReports.finalDate);
        print(filterReports.category.name);
        Future futureFilter = FirebaseFirestore.instance
            .collection('requisitions')
            .where('createdAt', isGreaterThanOrEqualTo: _selectedInitialDate)
            .where('createdAt', isLessThanOrEqualTo: _selectedFinalDate)
            .where('idCategory', isEqualTo: filterReports.category.id)
            .where('status', isEqualTo: 'APROVADO')
            .orderBy('createdAt', descending: true)
            .get();

        widget.onSubmit(futureFilter);
      }

// Filtro por departamento, sector e categoria
      if (filterReports.department != null &&
          filterReports.sector != null &&
          filterReports.provider == null &&
          filterReports.category != null) {
        print(filterReports.initialDate);
        print(filterReports.finalDate);
        print(filterReports.department.name);
        print(filterReports.sector.name);
        print(filterReports.category.name);
        Future futureFilter = FirebaseFirestore.instance
            .collection('requisitions')
            .where('createdAt', isGreaterThanOrEqualTo: _selectedInitialDate)
            .where('createdAt', isLessThanOrEqualTo: _selectedFinalDate)
            .where('idDepartment', isEqualTo: filterReports.department.id)
            .where('idSector', isEqualTo: filterReports.sector.id)
            .where('idCategory', isEqualTo: filterReports.category.id)
            .where('status', isEqualTo: 'APROVADO')
            .orderBy('createdAt', descending: true)
            .get();
        print("Filtro departamento, setor e categoria...");
        widget.onSubmit(futureFilter);
      }

      // Filtro por departamento e categoria
      if (filterReports.department != null &&
          filterReports.sector == null &&
          filterReports.provider == null &&
          filterReports.category != null) {
        print(filterReports.initialDate);
        print(filterReports.finalDate);
        print(filterReports.department.name);
        print(filterReports.category.name);
        Future futureFilter = FirebaseFirestore.instance
            .collection('requisitions')
            .where('createdAt', isGreaterThanOrEqualTo: _selectedInitialDate)
            .where('createdAt', isLessThanOrEqualTo: _selectedFinalDate)
            .where('idDepartment', isEqualTo: filterReports.department.id)
            .where('idCategory', isEqualTo: filterReports.category.id)
            .where('status', isEqualTo: 'APROVADO')
            .orderBy('createdAt', descending: true)
            .get();
        print("Filtro departamento e categoria...");
        widget.onSubmit(futureFilter);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          key: ValueKey('initialDate'),
                          controller: _initialDateController,
                          readOnly: true,
                          decoration:
                              InputDecoration(labelText: 'Data Inicial*'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Selecione a Data Inicial...';
                            }
                            return null;
                          },
                          onTap: _showInitialDatePicker,
                        ),
                        TextFormField(
                          key: ValueKey('finalDate'),
                          controller: _finalDateController,
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Data Final*'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Selecione a Data Final...';
                            }
                            return null;
                          },
                          onTap: _showFinalDatePicker,
                        ),
                        TextFormField(
                          key: ValueKey('department'),
                          controller: _nameDepartmentController,
                          readOnly: true,
                          decoration:
                              InputDecoration(labelText: 'Departamento'),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Selecione um Departamento...';
                          //   }
                          //   return null;
                          // },
                          onTap: () => _openDepartmentListModal(context),
                        ),
                        TextFormField(
                          key: ValueKey('sector'),
                          controller: _nameSectorController,
                          readOnly: true,
                          decoration:
                              InputDecoration(labelText: 'Centro de Custo'),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Selecione um Centro de Custo...';
                          //   }
                          //   return null;
                          // },
                          onTap: () => selectedDepartment != null
                              ? _openSectorListModal(context)
                              : _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Selecione um Departamento...'),
                                  backgroundColor: Colors.red,
                                )),
                        ),
                        TextFormField(
                          key: ValueKey('provider'),
                          controller: _fantasyNameProviderController,
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Fornecedor'),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Selecione um Fornecedor...';
                          //   }
                          //   return null;
                          // },
                          onTap: () => _openProviderListModal(context),
                        ),
                        TextFormField(
                          key: ValueKey('category'),
                          controller: _nameCategoryController,
                          readOnly: true,
                          decoration:
                              InputDecoration(labelText: 'Categoria da Compra'),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Selecione uma Categoria...';
                          //   }
                          //   return null;
                          // },
                          onTap: () => _openCategoryListModal(context),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                              child: Text('Filtrar'),
                              color: Theme.of(context).primaryColor,
                              textColor:
                                  Theme.of(context).textTheme.button.color,
                              // onPressed: () => null,
                              onPressed: _submitForm,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
