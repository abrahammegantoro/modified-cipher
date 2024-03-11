import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'cipher_item.dart';

class CipherListView extends StatelessWidget {
  const CipherListView({
    Key? key,
    this.items = const [
      CipherItem(
        id: 1,
        title: "Extended Vigenere Cipher",
        description:
            "The Extended Vigenere Cipher is a variation of the Vigenere Cipher that allows a wider range of characters in the key and plaintext.",
        route: "/extended-vigenere-cipher",
      ),
      CipherItem(
        id: 2,
        title: "Playfair Cipher",
        description:
            "The Playfair Cipher is a digraph substitution cipher that encrypts pairs of letters instead of single letters.",
        route: "/playfair-cipher",
      ),
      CipherItem(
        id: 3,
        title: "Affine CIpher",
        description:
            "The Affine Cipher is a type of monoalphabetic substitution cipher, wherein each letter in an alphabet is mapped to its numeric equivalent, encrypted using a simple mathematical function, and converted back to a letter.",
        route: "/affine-cipher",
      )
    ],
  }) : super(key: key);

  static const routeName = '/';

  final List<CipherItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cipher List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'CipherListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
            onTap: () {
              Navigator.restorablePushNamed(
                context,
                item.route,
                arguments: {
                  'title': item.title,
                  'description': item.description,
                },
              );
            },
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(item.description, textAlign: TextAlign.justify),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 4);
        },
      ),
    );
  }
}
