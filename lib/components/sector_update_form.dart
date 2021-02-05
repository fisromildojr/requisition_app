import 'package:flutter/material.dart';
import 'package:requisition_app/models/sector.dart';

class SectorUpdateForm extends StatefulWidget {
  final void Function(Sector sector) onSubmit;
  final Sector sector;

  SectorUpdateForm(this.onSubmit, this.sector);

  @override
  _SectorUpdateFormState createState() => _SectorUpdateFormState();
}

class _SectorUpdateFormState extends State<SectorUpdateForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  _submitForm() {
    bool isValid = _formKey.currentState.validate();

    if (isValid) {
      final sector = Sector(
        id: widget.sector.id,
        name: widget.sector.name,
      );

      widget.onSubmit(sector);
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
                initialValue: widget.sector.name,
                onChanged: (value) => this.widget.sector.name = value,
                decoration: InputDecoration(
                  labelText: 'Nome do Centro de Custo',
                ),
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
