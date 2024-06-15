import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Age Calculator',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white, // White background color
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String myAge = '';
  String daysUntilNextBirthday = '';
  int birthdaysCelebrated = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Age Calculator",
          style: TextStyle(color: Colors.white), // White text color
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900], // Dark blue background color
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blue[900], // Match status bar color with AppBar
        ),
      ),
      backgroundColor: Colors.white, // White background color for the entire screen
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.lightBlue[100], // Light blue card color
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cake, color: Colors.deepOrange, size: 30),
                      const SizedBox(width: 10),
                      const Text(
                        'Your age is',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cake, color: Colors.deepOrange, size: 30),
                      const SizedBox(width: 10),
                      Text(
                        myAge,
                        style: const TextStyle(fontSize: 25, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (daysUntilNextBirthday.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.deepOrange, size: 30),
                        const SizedBox(width: 10),
                        const Text(
                          'Days until next birthday: ',
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                        Text(
                          daysUntilNextBirthday,
                          style: const TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cake, color: Colors.deepOrange, size: 30),
                      const SizedBox(width: 10),
                      const Text(
                        'Birthdays celebrated: ',
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      Text(
                        '$birthdaysCelebrated',
                        style: const TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () => pickDob(context),
                    icon: const Icon(Icons.date_range, color: Colors.white), // Icon for button
                    label: const Text(
                      'Pick Date of Birth',
                      style: TextStyle(color: Colors.white), // White button text color
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickDob(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        calculateAge(pickedDate);
        calculateDaysUntilNextBirthday(pickedDate);
        calculateBirthdaysCelebrated(pickedDate);
      }
    });
  }

  void calculateAge(DateTime birth) {
    DateTime now = DateTime.now();
    Duration age = now.difference(birth);
    int years = age.inDays ~/ 365;
    int months = (age.inDays % 365) ~/ 30;
    int days = ((age.inDays % 365) % 30);
    setState(() {
      myAge = '$years years, $months months, and $days days';
    });
  }

  void calculateDaysUntilNextBirthday(DateTime birth) {
    DateTime now = DateTime.now();
    DateTime nextBirthday = DateTime(now.year, birth.month, birth.day);
    if (nextBirthday.isBefore(now) || nextBirthday.isAtSameMomentAs(now)) {
      nextBirthday = DateTime(now.year + 1, birth.month, birth.day);
    }
    Duration difference = nextBirthday.difference(now);
    setState(() {
      daysUntilNextBirthday = '${difference.inDays} days';
    });
  }

  void calculateBirthdaysCelebrated(DateTime birth) {
    DateTime now = DateTime.now();
    int yearsOld = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      yearsOld--;
    }
    setState(() {
      birthdaysCelebrated = yearsOld;
    });
  }
}
