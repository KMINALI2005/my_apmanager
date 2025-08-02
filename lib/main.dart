import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/debt_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DebtProvider(),
      child: MaterialApp(
        // إعدادات اللغة العربية و RTL
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'AE'), // اللغة العربية
        ],
        locale: const Locale('ar', 'AE'), // تحديد اللغة العربية كلغة افتراضية

        title: 'Debt Manager',
        
        // تصميم عصري وجذاب
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          fontFamily: 'Cairo', // يمكنك إضافة خط عربي مخصص مثل Cairo
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.bold),
          ),
          textTheme: const TextTheme( // تحديد الخطوط للنصوص المختلفة
            titleLarge: TextStyle(fontFamily: 'Cairo'),
            bodyMedium: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
        darkTheme: ThemeData(
           useMaterial3: true,
           colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          fontFamily: 'Cairo',
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.bold),
          ),
           textTheme: const TextTheme(
            titleLarge: TextStyle(fontFamily: 'Cairo'),
            bodyMedium: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
        themeMode: ThemeMode.system, // يتبع وضع النظام (داكن/فاتح)

        home: const HomeScreen(),
      ),
    );
  }
}
