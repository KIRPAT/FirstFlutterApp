//Flutter Libs
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
//Components
import '../components/styled_text/price_tag.dart';
import '../components/styled_text/default_product_title.dart';
import '../components/styled_text/location_tag.dart';
//Scoped-Model Models
import '../scoped-models/products_scoped_model.dart';
//Models
import '../models/product_model.dart';

class ProductDetailsPage extends StatelessWidget{
  //CONSTRUCTOR (we will get rid of it soon)
  final int index;
  ProductDetailsPage(this.index);

  //METHODS
  //showDialog() is dismissed through Navigation.pop() too
  void _popPage(context) => Navigator.pop(context, true);
  void _onWillPop(context) => Navigator.pop(context, false);

  /*
  void _showDeleteDialog(context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('You can not undelete it once it is gone.'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('DISCARD')
            ),
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
                _popPage(context); //pop with "true" as a second argument,
              },
              child: Text('CONTINUE')
            ),
          ],
        );
      }
    );
  }
  */
  //WIDGETS
  Widget _image(String imageURL){
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Image.asset(imageURL),
      ),
    );
  }
  Widget _titleAndPrice(String title, double price){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Center(
            child: DefaultProductTitle(title), //Custom Widget
          ),
          //constraints:BoxConstraints(maxWidth: 200.0),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: PriceTag(price),
          ),
        ),
      ],
    );
  }
  Widget _divider(){
    return Padding(
      padding: EdgeInsets.only(top: 13.0, bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: SizedBox(), flex:1),
          Expanded(
            flex: 3,
            child: Container(
              height: 1.0,
              color: Colors.grey,
            ),
          ),
          Expanded(child: SizedBox(), flex:1),
        ],
      ),
    );
  }

  Widget _details(String description){
    return Container(
      child: Column(children: <Widget>[
        Text('Details:', style: TextStyle(fontStyle: FontStyle.italic, fontFamily: 'Oswald', fontSize: 15.0),),
        SizedBox(height: 6.0,),
        Text(description),
      ],)
    );
  }

  //Rendered Widget
  Widget _scaffold(BuildContext context){
    return ScopedModelDescendant<ProductsModel>(builder:(BuildContext context, Widget child, ProductsModel model){
      /* Note: Refactoring for Scoped Model
      The data of the "Product" is no longer received through the constructor. Why? Scoped Model exists, and it is beautiful.
      So, we need to access the data of scoped model, and pass them into following column widgets properly.
      */
      final Product _product = model.products[index];
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Details', style: TextStyle(color: Colors.white)),
        ),
        body:SingleChildScrollView( //Scrollable details page
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            //The main Column
            child: Column(
              children: <Widget>[
                /*
                What if the product has more than one image? Food for a thought.
                 */
                _image(_product.image),
                _titleAndPrice(_product.title, _product.price),
                LocationTag(_product.location),
                _divider(),
                //Details
                _details(_product.description),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _listenedScaffold(BuildContext context){
    /*
    WillPopScope widget decides if the user is allowed to return from a page,
    either through the Android's back button,
    or the the app's own back button that is placed on the AppBar.
    True, False

    If we place...
    Navigator.pop(context, false);
    ...on top of the...
    return Future.value(true);
    ...something weird happens.

    We pop twice, and actually pop the homepage itself.
    Thus, a black screen.
    To prevent that from happening. we actually need to use
    Future.value(false);
    Yes, we are actually preventing the user from going back but the
    Navigator.pop(context, false); lets us go back anyways.
    */
    return WillPopScope(
      child: _scaffold(context),
      onWillPop:(){
        _onWillPop(context);
        return Future.value(false);
      }
    );
  }

  //BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return _listenedScaffold(context);
  }
}