import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kadena_multisig/pages/page_data.dart';
import 'package:kadena_multisig/pages/transaction_builder_page.dart';
import 'package:kadena_multisig/pages/settings_page.dart';
import 'package:kadena_multisig/services/kadena/i_kadena_service.dart';
import 'package:kadena_multisig/services/kadena/kadena_provider.dart';
import 'package:kadena_multisig/services/wallet_connect/i_wallet_connect_service.dart';
import 'package:kadena_multisig/services/wallet_connect/wallet_connect_service.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/utils/dart_defines.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:kadena_multisig/widgets/dependency_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationSupportDirectory(),
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StringConstants.title,
      theme: ThemeData(
        primaryColor: StyleConstants.primaryColor,
        backgroundColor: StyleConstants.backgroundColor,
        scaffoldBackgroundColor: const Color(0xFF111B25),
        textTheme: ThemeData.light()
            .textTheme
            .copyWith(
              titleSmall: const TextStyle(
                fontSize: 12,
                // fontWeight: FontWeight.w700,
              ),
              titleMedium: const TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.w100,
              ),
              titleLarge: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            )
            .apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: StyleConstants.primaryColor,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: StyleConstants.backgroundColor,
          titleTextStyle: TextStyle(color: Colors.white),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: StyleConstants.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        primaryIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: StyleConstants.primaryColor,
        ),
        canvasColor: StyleConstants.backgroundColorLighter,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white60),
          iconColor: StyleConstants.primaryColor,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: StyleConstants.backgroundColorLighter),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: StyleConstants.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: StyleConstants.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: StyleConstants.backgroundColorLighter,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
        ),
        navigationRailTheme: const NavigationRailThemeData(
          elevation: 100,
          backgroundColor: StyleConstants.backgroundColorLighter,
          selectedIconTheme: IconThemeData(color: Colors.white),
          selectedLabelTextStyle: TextStyle(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.white),
          unselectedLabelTextStyle: TextStyle(color: Colors.white),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return StyleConstants.primaryColor;
            }
            return StyleConstants.backgroundColorLighter;
          }),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      home: DependencyWidget(
        child: Root(
          pageDatas: [
            PageData(
              page: const TransactionBuilderPage(),
              title: StringConstants.txBuilderPage,
              iconTitle: StringConstants.txBuilderPageIcon,
              icon: Icons.build,
            ),
            PageData(
              page: SettingsPage(),
              title: StringConstants.txMetadataPage,
              iconTitle: StringConstants.txMetadataPageIcon,
              icon: Icons.merge_type_sharp,
            ),
            PageData(
              page: const Center(
                child: Text(
                  'Multisig (Not Implemented)',
                  style: StyleConstants.bodyText,
                ),
              ),
              title: StringConstants.multisigPage,
              iconTitle: StringConstants.multisigPageIcon,
              icon: Icons.group_add_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class Root extends StatefulWidget {
  const Root({
    super.key,
    required this.pageDatas,
  });

  final List<PageData> pageDatas;

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> navRail = [];
    if (MediaQuery.of(context).size.width >= Constants.smallScreen) {
      navRail.add(_buildNavigationRail());
    }
    navRail.add(
      Expanded(
        child: widget.pageDatas[_selectedIndex].page,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            height: 100,
            child: SvgPicture.asset(
              'assets/images/KadenaKodeLogo.svg',
              height: 10,
              // width: 80,
            ),
          ),
        ),
        title: Text(widget.pageDatas[_selectedIndex].title),
      ),
      bottomNavigationBar:
          MediaQuery.of(context).size.width < Constants.smallScreen
              ? _buildBottomNavBar()
              : null,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: navRail,
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      // unselectedItemColor: Colors.grey,

      // called when one tab is selected
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      // bottom tab items
      items: widget.pageDatas
          .map(
            (e) => BottomNavigationBarItem(
              icon: Icon(e.icon),
              label: e.iconTitle,
            ),
          )
          .toList(),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      // backgroundColor: StyleConstants.backgroundColor,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      labelType: NavigationRailLabelType.selected,
      destinations: widget.pageDatas
          .map(
            (e) => NavigationRailDestination(
              icon: Icon(e.icon),
              label: Text(e.iconTitle),
            ),
          )
          .toList(),
    );
  }
}
