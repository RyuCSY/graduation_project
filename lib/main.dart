import 'package:attendance/ui/license_screen.dart';
import 'package:attendance/ui/history_screen.dart';
import 'package:attendance/ui/outline_text.dart';
import 'package:attendance/ui/scan_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Colors.cyanAccent,
              Colors.cyan,
              Colors.lightBlue,
              Colors.blue,
              Colors.blueGrey,
            ],
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('메인화면', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Column(children: [
            const Spacer(),
            Text(
              '출퇴근 관리 앱',
              style: OutlineTextStyle(txtColor: Colors.white, lineColor: Colors.blueGrey),
            ),
            const Spacer(),
            Row(
                children: [
              ScreenObject('QR 스캔', Text(''), addAction: () async {
                final sendData = await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('출퇴근 관리앱.'),
                          content: const Text('출근/퇴근 여부를 선택하세요.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('출근'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('퇴근'),
                            ),
                          ],
                        ));

                return ScanScreen(sendData);
              }),
              ScreenObject('출퇴근\n내역 조회', HistoryScreen()),
              ScreenObject('오픈\n라이선스', const LicenseScreen()),
            ]
                    .map((obj) => Expanded(
                          flex: 33,
                          child: InkWell(
                            onTap: () async {
                              {
                                Widget? nextScreen;

                                if (obj.addAction != null) {
                                  nextScreen = await obj.addAction!();
                                }

                                String? rcvData = await Navigator.of(
                                  context,
                                ).push(PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => (nextScreen == null) ? obj.screen : nextScreen,
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ));

                                if (rcvData != null) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                            title: const Text('결과.'),
                                            content: Text(rcvData ?? ''),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                                child: const Text('확인'),
                                              ),
                                            ],
                                          ));
                                }
                              }
                            },
                            child: Container(
                              height: 111,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ),
                              //  POINT: BoxDecoration
                              child: Text(
                                obj.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.purple, fontSize: 22.0),
                              ),
                            ),
                          ),
                        ))
                    .toList()),
            const Spacer(),
          ]),
        ),
      ),
    ]);
  }
}

class ScreenObject {
  final String title;
  final Widget screen;
  Function? addAction;

  ScreenObject(this.title, this.screen, {Function? this.addAction});
}
