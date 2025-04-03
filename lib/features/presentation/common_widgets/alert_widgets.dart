import 'package:flutter/material.dart';

class AlertWidgets {
  final BuildContext context;
  AlertWidgets(this.context);

  showCommonAlertDialog({
    String? title,
    required String content,
    String? actionBtnTxt,
    VoidCallback? action,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog.adaptive(
            title: title != null ? Text(title) : null,
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              if (actionBtnTxt != null)
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    action != null ? action() : null;
                  },
                  child: Text(actionBtnTxt),
                ),
            ],
          ),
    );
  }
}
