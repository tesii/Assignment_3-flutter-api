import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  ThemeData _lightTheme = ThemeData.light();
  ThemeData _darkTheme = ThemeData.dark().copyWith(primaryColor: Colors.black);
  ThemeData _currentTheme = ThemeData.light();
  late SharedPreferences _prefs;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _tabController = TabController(length: 3, vsync: this);
  }

  _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_prefs.getBool('isDark') == null) {
        _currentTheme = _lightTheme;
        _prefs.setBool('isDark', false);
      } else if (_prefs.getBool('isDark')!) {
        _currentTheme = _darkTheme;
      } else {
        _currentTheme = _lightTheme;
      }
    });
  }

  _switchTheme() async {
    setState(() {
      if (_currentTheme == _darkTheme) {
        _currentTheme = _lightTheme;
        _prefs.setBool('isDark', false);
      } else {
        _currentTheme = _darkTheme;
        _prefs.setBool('isDark', true);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _currentTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calculator App'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.logout), text: 'Sign In'),
              Tab(icon: Icon(Icons.app_registration), text: 'Sign Up'),
              Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: _switchTheme,
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            CalculatorApp(),
            CalculatorApp(),
            CalculatorApp(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Sign In'),
                onTap: () {
                  _tabController.animateTo(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.app_registration),
                title: Text('Sign Up'),
                onTap: () {
                  _tabController.animateTo(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calculate),
                title: Text('Calculator'),
                onTap: () {
                  _tabController.animateTo(2);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}