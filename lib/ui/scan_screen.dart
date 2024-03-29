import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanScreen extends StatefulWidget {
  bool isAtt;
  String retMsg = '취소 하였습니다.';

  ScanScreen(this.isAtt, {super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  final cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool isCameraGranted = false;
  bool isShowingDialog = false;
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, widget.retMsg);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('스캔', style: TextStyle(color: Colors.white)),
        ),
        body: (!isCameraGranted)
            ? Container(color: Colors.black)
            : Stack(
                children: [
                  MobileScanner(
                      controller: cameraController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null && !isFinished) {
                            final scanData = barcode.rawValue!;

                            isFinished = true;

                            if (scanData.startsWith('rapps:')) {
                              widget.retMsg = (widget.isAtt) ? '출근' : '퇴근';
                              widget.retMsg += '기록에 성공 하였습니다. (${DateFormat('HH:mm').format(DateTime.now())})';
                            } else {
                              widget.retMsg = '올바른 QR 코드가 아닙니다.';
                            }
                            Navigator.pop(context, widget.retMsg);
                            return;
                          }
                        }
                      }),
                  const CameraFrameWidget(),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: AlignmentDirectional.topCenter,
                    padding: const EdgeInsets.only(top: 55),
                    child: const Text(
                      '코드를 스캔 하세요.',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void initState() {
    requestPermission(context, Permission.camera, () => showPermissionDialog());
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      requestPermission(context, Permission.camera, () => showPermissionDialog());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }

  Future<void> requestPermission(BuildContext context, Permission permission, Function callback) async {
    if (isShowingDialog) {
      return;
    }

    final status = await permission.request();

    if (status.isGranted) {
      if (isShowingDialog) {
        isShowingDialog = false;
        Navigator.pop(context);
      }
      setState(() {
        isCameraGranted = true;
      });
    } else if (!isShowingDialog) {
      callback();
    }
  }

  void showPermissionDialog() {
    if (!isShowingDialog) {
      isShowingDialog = true;
      bool isCancel = true;

      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('카메라 권한이 필요합니다.'),
                content: const Text('설정에서 카메라 권한을 허용 하세요.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Future<void>.delayed(Duration.zero, () => openAppSettings());
                      isCancel = false;
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              )).then((_) {
        isShowingDialog = false;
        if (isCancel) {
          Navigator.pop(context);
        }
      });
    }
  }
}

class CameraFrameWidget extends StatelessWidget {
  const CameraFrameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent, body: _getCustomPaintOverlay(context));
  }

  CustomPaint _getCustomPaintOverlay(BuildContext context) {
    return CustomPaint(size: MediaQuery.of(context).size, painter: RectanglePainter());
  }
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final squareSize = size.width * 0.8;
    final centerPosition = Offset(size.width * 0.5, size.height * 0.5);

    var paint = Paint()..color = Colors.black.withOpacity(0.4);
    var path = Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: centerPosition, width: squareSize, height: squareSize), const Radius.circular(15)))
          ..close());

    canvas.drawPath(path, paint);

    paint = Paint()
      ..color = Colors.lightBlue.withOpacity(0.44)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: centerPosition, width: squareSize, height: squareSize), const Radius.circular(15)))
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
