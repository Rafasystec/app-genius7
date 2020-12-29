
import 'package:app/main/main_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'main/main_widget.dart';

void main() => runApp(
    ModularApp(
      module: AppMainModule(),
    )
);

