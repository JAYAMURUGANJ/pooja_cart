// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class HeadContainer extends StatefulWidget {
  Widget child;
  HeadContainer({super.key, required this.child});

  @override
  State<HeadContainer> createState() => _HeadContainerState();
}

class _HeadContainerState extends State<HeadContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.inversePrimary,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
