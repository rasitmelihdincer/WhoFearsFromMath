import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonAlertDialog extends StatelessWidget {
  // final Image _image;
  final String _textName;
  final Icon _icon;
  const CommonAlertDialog({
    Key? key,
    required Icon icon,
    required String textName,
  })  : _icon = icon,
        _textName = textName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _icon,
          const SizedBox(height: 16.0),
          Text(
            _textName,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}

class CommonCard extends StatelessWidget {
  final String _title;
  const CommonCard({Key? key, required String title})
      : _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Center(
          child: Text(
            _title,
          ),
        ),
      ),
    );
  }
}

class NumberFormField extends StatefulWidget {
  const NumberFormField({
    Key? key,
    required TextEditingController controller,
    required String label,
    required TextInputType textInputType,
  })  : _controller = controller,
        _label = label,
        _textInputType = textInputType,
        super(key: key);

  final TextEditingController _controller;
  final String _label;
  final TextInputType _textInputType;

  @override
  State<NumberFormField> createState() => _NumberFormFieldState();
}

class _NumberFormFieldState extends State<NumberFormField> {
  @override
  void initState() {
    super.initState();
    widget._controller.addListener(onChange);
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }

  void onChange() {
    if (widget._controller.text.isNotEmpty) {
      FocusScope.of(context).nextFocus();
    }
  }

  String validateForm(String val) {
    if (widget._controller.text == "" || widget._controller.text.isEmpty) {
      return 'Cannot be empty';
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: ((value) => validateForm(widget._controller.text)),
      style: const TextStyle(fontSize: 18.0),
      //textInputAction: TextInputAction.next,
      textAlign: TextAlign.center,
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
      ],
      maxLength: 1,
      controller: widget._controller,
      keyboardType: widget._textInputType,
      decoration: InputDecoration(
        label: Text(widget._label),
        counterText: "",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
      ),
    );
  }
}
