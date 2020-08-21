import 'package:app/components/pro_rating.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/enums/from_screen_enum.dart';
import 'package:app/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

class RatingComment extends StatefulWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final bool isLogged;
  final String reviewsReference;
  final String reviewOwnerReference;
  RatingComment(this.snapshot,this.reviewOwnerReference,{this.isLogged = false,this.reviewsReference});
  @override
  _RatingCommentState createState() => _RatingCommentState();
}

class _RatingCommentState extends State<RatingComment> {
  String _userRef,_urlAvatar,_nickName;
  SharedPreferences prefs;
  TextEditingController commentController;
  double _rate = 0.0;
  bool isLoggedIn = false;
  @override
  void initState() {
    commentController = TextEditingController();
    isLoggedIn = widget.isLogged;
    readLocal();
    super.initState();
  }

  void readLocal() async{
    prefs     = await SharedPreferences.getInstance();
    _userRef  = prefs.getString(USER_REF);
    _urlAvatar = prefs.getString(PHOTO_URL);
    _nickName = prefs.getString(NICK_NAME);
  }

  @override
  Widget build(BuildContext context) {
    int length = widget.snapshot.data.documents.length;
    return length == 0 ? emptyContainer(context) : listComments(context,length) ;
  }


  Widget emptyContainer(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Visibility(visible: isLoggedIn, child: Text('Nenhum comentário, seja o primeiro')),
          buildCommentButton(),
          //TODO add edit text to comment
          logginButton(context),
          Container(
              padding: EdgeInsets.all(8.0),
              child: Visibility(
                visible: !isLoggedIn,
                child: Text('LOGAR é quando você utiliza as suas credencias para entrar no App.'),
              )
          )
        ],
      ),
    );
  }

  Container logginButton(BuildContext context) {
    return Container(
            padding: EdgeInsets.all(8.0),
            child: Visibility(
                visible: !isLoggedIn,
                child: appButtonTheme(context, 'LOGAR E COMENTAR', (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(FromScreen.JUST_CLOSE, title: 'Faça o login',))).then((value) {
                    if(value == null) return;
                    if(value){
                      setState(() {
                        isLoggedIn = true;
                      });
                    }
                  });
                })
            )
        );
  }

  Widget buildCommentButton(){
    return Container(
      child: Column(
        children: <Widget>[
          Visibility(
            visible: isLoggedIn,
            child: formFieldText('Faça seu comentário', (value) {
//              if (value.isEmpty) {
//                return 'Por favor informar o nome do prato';
//              }
              return null;
            },controller: commentController),
          ),
          SizedBox(height: 15,),
          Visibility(visible: isLoggedIn, child: appButtonTheme(context, 'ENVIAR',  () {
            Firestore.instance.collection(widget.reviewsReference)
                .add({'avatar': _urlAvatar,
              'user-name':_nickName,
              'comment': commentController.text,
              'rate': _rate,
              'user-ref': _userRef
            }).then((value) {
                var ref = value.documentID;
                var tempRate = 0.0;
                print(ref);
                setState(() {
                  commentController.text = '';
                  tempRate = _rate.abs();
                  _rate = 0.0;
                });

                Firestore.instance.document(widget.reviewOwnerReference).get().then((value){
                  var newItemRates  = (value['rates'] ?? 0.0) + 1;
                  var totalRate     = (value['total-rate'] ?? 0.0) + tempRate;
                  var newItemRate   =  totalRate / newItemRates ;

                  Firestore.instance.document(widget.reviewOwnerReference).updateData({
                    'rate':newItemRate,
                    'rates':newItemRates,
                    'total-rate': totalRate
                  });
                });


            });
            Fluttertoast.showToast(msg: 'Obrigado pelo comentário');
          },height: 35.0)),
        ],
      ),
    );
  }

  Widget listComments(BuildContext context, int length){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          logginButton(context),
          ratingBar(),
          buildCommentButton(),
          Container(
            height: 200.0,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: length,
                itemBuilder: (BuildContext context, int index){
                  DocumentSnapshot item = widget.snapshot.data.documents[index];
                  return buildRatingFromSnapshot(context,item);
                }
            ),
          )
        ],
      ),
    );
  }

  Widget ratingBar() {
    return Visibility(
      visible: isLoggedIn,
      child: RatingBar(
            initialRating: _rate,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print('rating: $rating');
              try{
                _rate = rating;
              }catch(e){
              }
            },
          ),
    );
  }

}


