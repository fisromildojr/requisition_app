import 'package:requisition_app/models/category.dart';
import 'package:flutter/material.dart';

class CategoryUpdateForm extends StatefulWidget {
  final void Function(Category) onSubmit;
  final Category category;

  CategoryUpdateForm(this.onSubmit, this.category);
  @override
  _CategoryUpdateFormState createState() => _CategoryUpdateFormState();
}

class _CategoryUpdateFormState extends State<CategoryUpdateForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  _submitForm() {
    bool isValid = _formKey.currentState.validate();
    if (isValid) {
      final category = Category(
        id: widget.category.id,
        name: widget.category.name,
      );

      widget.onSubmit(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 450,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        key: ValueKey("name"),
                        initialValue: widget.category.name,
                        onChanged: (value) => this.widget.category.name = value,
                        decoration: InputDecoration(
                          labelText: 'Nome da Categoria',
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
            ],
          ),
        ),
      ),
    );
  }
}
