import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  //CONSTRUCTOR
  final Function addProduct;
  ProductCreatePage(this.addProduct);

  //STATE
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage>{
  //STATES
  final Map<String, dynamic> _formData={
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/lmr.png',
    'location': 'İstanbul, Taksim',
  };

  final GlobalKey<FormState> _productFormKey = new GlobalKey<FormState>();
  //METHODS
  /* Note_1 - Modal Example
  void _modal(context){ //modals return future too, if needed.
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Text('This is a modal.'),
        );
      },
    );
  }

  Widget _render(context){
    return Center(
      child: RaisedButton(
        onPressed: (){
          _modal(context);
        }
      ),
    );
  }

  then BUILD METHOD
  */
  void _submitForm(){
    //if the validation returns false do not save
    if (!_productFormKey.currentState.validate()){return;}
    _productFormKey.currentState.save();
    widget.addProduct(_formData);
    Navigator.pushReplacementNamed(context, '/home ');
  }
  //STYLE
  InputDecoration _formInputDecoration(String labelText) {
    return  InputDecoration(
      labelText: labelText ,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      )
    );
  }
  //WIDGETS
  /*
  This widget became too verbose and redundant.
  I need to create a text input widget and call it here.
   */
  Widget _render(context){
    //RegExp
    final String _passwordRegExp = r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$';
    //Media Query (for screen rotation)
    final _width = MediaQuery.of(context).size.width;
    final _targetWidth = _width > 550 ? 500.0 : _width * 0.9;
    final _targetPadding = _width - _targetWidth;

    return GestureDetector(
      onTap: (){FocusScope.of(context).requestFocus(FocusNode());}, //to close keyboard when tap on empty space
      child: Container(
        width: 300,
        child: Form(
          key: _productFormKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: _targetPadding / 1.5),
            children: <Widget>[
              //TITLE
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: _formInputDecoration('Title'),
                  validator: (String value){
                    if (value.isEmpty || value.length <= 5) {
                      return '*Title is required, and it should be at least 5 characters long.';
                    }
                  },
                  onSaved: (String value) { //Called NOT on every key stroke, but whenever we call the save() method.
                    _formData['title'] = value;
                  },
                ),
              ),

              //DESCRIPTION
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: _formInputDecoration('Description'),
                  maxLines: 4,
                  validator: (String value){
                    if (value.isEmpty || value.length <= 10) {
                      return '*Description is required, and it should be at least 10 characters long.';
                    }
                  },
                  onSaved: (String value) { //Called NOT on every key stroke, but whenever we call the save() method.
                      _formData['description'] = value;
                  },
                ),
              ),

              //PRICE
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: _formInputDecoration('Price'),
                  keyboardType: TextInputType.number,
                  validator: (String value){
                    if (value.isEmpty || !RegExp(_passwordRegExp).hasMatch(value)) {
                      return 'Price should be a valid number.';
                    }
                  },
                  onSaved: (String value) { //Called NOT on every key stroke, but whenever we call the save() method.
                      _formData['price'] = double.parse(value);
                  },
                ),
              ),

              //BUTTON
              Container(
                margin: EdgeInsets.symmetric(horizontal: 80),
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: _submitForm,
                  child: Text('Add Product!', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //BUILD
  @override
  Widget build(BuildContext context) {
    return _render(context);
  }
}