import 'package:flutter/material.dart';
import 'package:gestobjetapp/data/notifiers.dart';
import 'package:gestobjetapp/features/locations/presentation/pages/salle_page.dart';
import 'package:gestobjetapp/features/settings/presentation/pages/settings_page.dart';
import 'package:gestobjetapp/features/app/presentation/widgets/navbar_widget.dart';

List<Widget> pages = [HomePage(), SettingsPage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Gest Objet"))),
      body: ValueListenableBuilder(
        valueListenable: selectPageNotifier,
        builder: (context, value, child) {
          return pages.elementAt(value);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
