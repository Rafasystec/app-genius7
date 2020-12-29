import 'package:app/main/main_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../choice_account.dart';

class AppMainModule extends MainModule{
  @override
  // TODO: implement binds
  List<Bind> get binds => [];

  @override
  // TODO: implement bootstrap
  Widget get bootstrap => MyApp();

  @override
  // TODO: implement routers
  List<ModularRouter> get routers => [
    ModularRouter('/',child: (_,args) => ChooseTypeAccount())
  ];

}