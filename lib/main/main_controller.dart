
import 'package:mobx/mobx.dart';

abstract class MainController with Store{

  @observable
  var counter =0;

  @action
  increment(){
    counter++;
  }
}