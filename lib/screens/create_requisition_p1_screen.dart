import 'package:flutter/material.dart';
import 'package:requisition_app/utils/app_routes.dart';

class CreateRequisitionP1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitar Requisição"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Data da Compra'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fornecedor'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Departamento'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Centro de Custo'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Categoria'),
              ),
              Divider(),
              ButtonTheme(
                splashColor: Theme.of(context).primaryColor,
                height: 40.0,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.CREATE_REQUISITION_P2,
                    );
                  },
                  color: Theme.of(context).primaryColor,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Text("Próximo"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
