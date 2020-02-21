import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:kedul_app_main/screens/calendar_main_screen.dart';
import 'package:kedul_app_main/screens/profile_main_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState();

  int _selectedIndex = 0;

  final List<Widget> _mainScreens = <Widget>[
    CalendarMainScreen(),
    CalendarMainScreen(),
    CalendarMainScreen(),
    CalendarMainScreen(),
    ProfileMainScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Scaffold(
        body: _mainScreens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Feather.calendar),
              title: Text(
                'CALENDAR',
                style: theme.textStyles.caption,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.printer),
              title: Text(
                'SALE',
                style: theme.textStyles.caption,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.briefcase),
              title: Text(
                'MANAGE',
                style: theme.textStyles.caption,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.bar_chart),
              title: Text(
                'PROGRESS',
                style: theme.textStyles.caption,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Feather.user),
              title: Text(
                'PROFILE',
                style: theme.textStyles.caption,
              ),
            ),
          ],
          backgroundColor: theme.colors.content,
          unselectedItemColor: theme.colors.textDefault,
          selectedItemColor: theme.colors.textPrimary,
          showUnselectedLabels: true,
          selectedLabelStyle: theme.textStyles.caption,
          unselectedLabelStyle: theme.textStyles.caption,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
