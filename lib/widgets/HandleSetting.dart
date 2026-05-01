import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:memory_weave/providers/Auth_provider.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:provider/provider.dart';

/// Shows the appropriate settings dialog based on [index].
void handleSetting(BuildContext context, int index) {
  switch (index) {
    case 0: // Account Security
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Account Security",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.lock_reset, color: AppColors.primaryBlue),
                title: const Text("Change Password"),
                onTap: () async {
                  final auth = context.read<AuthProvider>();
                  final email = auth.userData["email"] ?? "";
                  Navigator.pop(context);
                  await auth.resetPassword(email);
                  if (context.mounted) {
                    CherryToast.success(
                      title: const Text("Email Sent"),
                      description: Text(
                        "A password reset link was sent to $email",
                      ),
                      animationType: AnimationType.fromTop,
                    ).show(context);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );

    case 1: // Notification Preferences
      showDialog(
        context: context,
        builder: (_) => const _NotificationDialog(),
      );

    case 2: // Privacy & Weaving
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Privacy & Weaving",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Your memories are stored locally on your device and securely backed up to your personal Firebase account. No one else can access your data.",
            style: TextStyle(color: Colors.grey[700]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Got it"),
            ),
          ],
        ),
      );

    case 3: // Export Archive
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Export Archive",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Export feature is coming soon! You'll be able to download all your memories as a ZIP archive.",
            style: TextStyle(color: Colors.grey[700]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
  }
}

class _NotificationDialog extends StatefulWidget {
  const _NotificationDialog();

  @override
  State<_NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<_NotificationDialog> {
  bool dailyReminder = true;
  bool newMemoryAlert = false;
  bool weeklyDigest = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Notification Preferences",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            value: dailyReminder,
            activeColor: AppColors.primaryBlue,
            title: const Text("Daily Reminder"),
            subtitle: const Text("Remind me to add a memory each day"),
            onChanged: (val) => setState(() => dailyReminder = val),
          ),
          SwitchListTile(
            value: newMemoryAlert,
            activeColor: AppColors.primaryBlue,
            title: const Text("New Memory Alert"),
            subtitle: const Text("Notify when a memory is saved"),
            onChanged: (val) => setState(() => newMemoryAlert = val),
          ),
          SwitchListTile(
            value: weeklyDigest,
            activeColor: AppColors.primaryBlue,
            title: const Text("Weekly Digest"),
            subtitle: const Text("A summary of your week's memories"),
            onChanged: (val) => setState(() => weeklyDigest = val),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            CherryToast.success(
              title: const Text("Saved"),
              description: const Text("Notification preferences updated"),
              animationType: AnimationType.fromTop,
            ).show(context);
          },
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
