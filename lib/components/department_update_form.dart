import 'package:flutter/material.dart';
import 'package:requisition_app/models/department.dart';

class DepartmentUpdateForm extends StatefulWidget {
  final void Function(Department) onSubmit;
  final Department department;

  DepartmentUpdateForm(this.onSubmit, this.department);
  @override
  _DepartmentUpdateFormState createState() => _DepartmentUpdateFormState();
}

class _DepartmentUpdateFormState extends State<DepartmentUpdateForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  _submitForm() {
    bool isValid = _formKey.currentState.validate();

    if (isValid) {
      final Department department = Department(
        id: widget.department.id,
        name: widget.department.name,
        excluded: widget.department.excluded,
      );

      widget.onSubmit(department);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: ValueKey("name"),
                initialValue: widget.department.name,
                onChanged: (value) => this.widget.department.name = value,
                decoration: InputDecoration(
                  labelText: 'Nome do Departamento',
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return 'Forneça um nome válido...';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    child: Text('Atualizar'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: _submitForm,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
