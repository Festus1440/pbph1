import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pb_ph1/core/widgets/app_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class ManageCards extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PBDefaultAppBar(
        title: 'Manage Cards',
      ),
      body: 'test'.text.makeCentered(),
    );
  }

}