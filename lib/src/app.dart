import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:modified_cipher/src/ciphers/cipher_details_view.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'ciphers/cipher_list_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            // Check if arguments are provided
            final args = routeSettings.arguments as Map<String, dynamic>?;

            if (args != null &&
                args.containsKey('title') &&
                args.containsKey('description')) {
              // Handle route for EncryptDecryptPage with dynamic title and description
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) => CipherDetailsView(
                  title: args['title'],
                  description: args['description'],
                ),
              );
            } else {
              // Handle other routes (e.g., cipher routes)
              switch (routeSettings.name) {
                case SettingsView.routeName:
                  return MaterialPageRoute<void>(
                    settings: routeSettings,
                    builder: (BuildContext context) =>
                        SettingsView(controller: settingsController),
                  );
                case CipherListView.routeName:
                  return MaterialPageRoute<void>(
                    settings: routeSettings,
                    builder: (BuildContext context) => const CipherListView(),
                  );
                // Add more cases for other routes if needed
                default:
                  return MaterialPageRoute<void>(
                    settings: routeSettings,
                    builder: (BuildContext context) => const CipherListView(),
                  );
              }
            }
          },
        );
      },
    );
  }
}