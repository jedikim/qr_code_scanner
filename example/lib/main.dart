import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flashlight/flutter_flashlight.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


void main() {
  Flashlight.lightOn();
  runApp(MaterialApp(home: QRViewExample()));
  Flashlight.lightOn();
}

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();

}

class _QRViewExampleState extends State<QRViewExample> {
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //onStart();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child : Stack (
              children: <Widget>[
                Container(
                  height:50,
                  width: 50,
              child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
                ),
                Container(
                  color: Colors.pink,
                  height: 10.0,
                  width: 10.0,
                )
            ],
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('This is the result of scan: $qrText'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          onPressed: () {
                            //controller?.pauseCamera();
                            onPrepare();

                          },
                          child:
                              Text(flashState, style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          onPressed: () {
                            if (controller != null) {
                              controller.flipCamera();
                              if (_isBackCamera(cameraState)) {
                                setState(() {
                                  cameraState = frontCamera;
                                });
                              } else {
                                setState(() {
                                  cameraState = backCamera;
                                });
                              }
                            }
                          },
                          child:
                              Text(cameraState, style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          onPressed: () {
                            controller?.pauseCamera();
                          },
                          child: Text('pause', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          onPressed: () {
                            controller?.resumeCamera();
                          },
                          child: Text('resume', style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }
  Future<void> onStop() async {
    print('onStop');
    //Flashlight.lightOn();
    await Flashlight.lightOff();
    //controller.toggleFlash();
    //await Future.delayed(Duration(milliseconds: 1000), (){this.controller.flipCamera(); });
    await Future.delayed(Duration(milliseconds: 2000), (){ qrText = '';controller?.resumeCamera();});
    //await Future.delayed(Duration(milliseconds: 600), (){ this.controller.flipCamera();});
//    this.controller.flipCamera();
//    this.controller.toggleFlash();
  }
  Future<void> onStart() async {
    print('onStart');
    //Flashlight.lightOn();
    await Flashlight.lightOn();
    //controller.toggleFlash();
    //await Future.delayed(Duration(milliseconds: 1000), (){this.controller.flipCamera(); });
    await Future.delayed(Duration(milliseconds: 10), (){ onStop();});
    //await Future.delayed(Duration(milliseconds: 600), (){ this.controller.flipCamera();});
//    this.controller.flipCamera();
//    this.controller.toggleFlash();
  }
  Future<void> onPrepare() async {
   // print('onStart');
    //Flashlight.lightOn();
//    await Flashlight.lightOn();
    //controller.toggleFlash();
    controller?.pauseCamera();
    //await Future.delayed(Duration(milliseconds: 1000), (){this.controller.flipCamera(); });
    await Future.delayed(Duration(milliseconds: 800), (){ onStart();});
    //await Future.delayed(Duration(milliseconds: 600), (){ this.controller.flipCamera();});
//    this.controller.flipCamera();
//    this.controller.toggleFlash();
  }
  // ignore: avoid_void_async
  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    //await onStart();
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if (qrText == '') {
          //

          qrText = scanData;
          //controller.flipCamera();
          onPrepare();
          //onStart();
          //Flashlight.lightOn();
          //controller.toggleFlash();
          //Vibration.vibrate(duration: 200);


          //controller.toggleFlash();

          //onStop();

        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
