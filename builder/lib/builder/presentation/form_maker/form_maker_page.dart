import 'package:flutter/material.dart';

class AForm extends StatefulWidget {
  const AForm({Key? key}) : super(key: key);

  @override
  State<AForm> createState() => _AFormState();
}

class _AFormState extends State<AForm> {

  final _formKey = GlobalKey<FormState>();

  void funcshean() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(40),
              filled: true,
              fillColor: Colors.blue.shade100,
              border: OutlineInputBorder(),
              labelText: 'label',
              hintText: 'hint',
              helperText: 'help',
              counterText: 'counter',
              icon: Icon(Icons.star),
              prefixIcon: Icon(Icons.favorite),
              suffixIcon: Icon(Icons.park),
            ),
          ),
          ElevatedButton(
            child: Text("Submit"),
            onPressed: () {
              _formKey.currentState!.validate();
            },
          )
        ],
      ),
    );
  }
}
