import 'package:flutter/material.dart';
import 'package:gestobjetapp/services/objet_controller.dart';
import 'package:gestobjetapp/views/widgets/objet_filter_widget.dart';

class ObjetPage extends StatefulWidget {
  final String SalleId;
  const ObjetPage({super.key, required this.SalleId});

  @override
  State<ObjetPage> createState() => _ObjetPageState();
}

class _ObjetPageState extends State<ObjetPage> {
  late Future<List<Objet>> futureObjets;
  @override
  void initState() {
    super.initState();
    futureObjets = getObjetBySalle(widget.SalleId);
  }
  Widget build(BuildContext context) {
    return FutureBuilder<List<Objet>>(
      future: futureObjets,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('snapshot.data = ${snapshot.data}');
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Impossible de récuperer les objets'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No objets found'));
        } else {
          final objets = snapshot.data!;
          return 
          Scaffold(
          
            body: Column( 
              children: [
                Expanded(
                  child: ObjetFilterWidget(objets: objets), 
                ),

                TextButton.icon(
                  onPressed: () {},
                  label: Text("Verifier"),
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {}, 
                  child: Icon(Icons.add),
                )   
              ],
            ),
          );
        }
      },
    );
  }
}