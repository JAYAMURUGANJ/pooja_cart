import 'package:flutter/material.dart';

class UnitMasterWidget extends StatefulWidget {
  const UnitMasterWidget({super.key});

  @override
  State<UnitMasterWidget> createState() => _UnitMasterWidgetState();
}

class _UnitMasterWidgetState extends State<UnitMasterWidget> {
  
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Unit ${index + 1}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
            ],
          ),
        );
      },
    );
  }
}
