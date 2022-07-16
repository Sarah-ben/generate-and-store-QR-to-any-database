import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memoiresunday/shared/components/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

import 'dart:io';


class Qr extends StatelessWidget {
  GlobalKey globalKey=GlobalKey();
 var dateTime=DateTime.now();
  File? qrImage;

  @override
  Widget build(BuildContext context) {
   // print('time is ${dateTime}');
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        width: getWidth(context),
       height: getHeight(context),
       child: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             RepaintBoundary(
               key: globalKey,
               child: QrImage(
                 data: 'Hello world',
                 version: QrVersions.auto,
                 size: 240.0,
                 backgroundColor:  Colors.white,
                 errorStateBuilder: (cxt, err) {
                   return const Center(
                     child: Text(
                       "Something gone wrong ...",
                       textAlign: TextAlign.center,
                     ),
                   );
                 },
               ),
             ),
             const SizedBox(
               height: 20,
             ),
             ElevatedButton(
                 onPressed: () {
                   _captureAndSharePng(context)
                       .then((value) => uploadImageToFirebase( context));
                 },
                 child: const Text(
                   'Save&Share th QR',
                   style: TextStyle(color: Colors.white, fontSize: 18),
                 ))
           ],
         ),
       )
      ),
    );
  }
  Future<void> _captureAndSharePng(context) async {
    RenderRepaintBoundary? boundary =
    globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final tempDir = await getExternalStorageDirectory();
    final file = await File(
        '${tempDir!.path}/${DateTime.now().millisecondsSinceEpoch}.png')
        .create();
    qrImage=file;
    print('image url${file}');
    await file.writeAsBytes(pngBytes);

  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = qrImage!.path;
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(qrImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value) {
      print("Done pp : $value");
      FirebaseFirestore.instance.collection('qr').add({'qr_id': value});
    });
  }



}
