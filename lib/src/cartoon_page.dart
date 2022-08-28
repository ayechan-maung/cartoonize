import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartoonize/app_utils/own_permission.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:octo_image/octo_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';

class CartoonPage extends HookWidget {
  final String? image;
  final String? imagePath;
  CartoonPage({Key? key, this.image, this.imagePath}) : super(key: key);

  var imgProgress;
  OwnPermissionHandler permissionHandler = OwnPermissionHandler();

  @override
  Widget build(BuildContext context) {
    imgProgress = useState(0.0);
    shareFile = useState('');

    useEffect(() {
      permissionHandler.storagePermission();
      return () {};
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cartoonized',
          style: GoogleFonts.kalam(textStyle: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              OctoImage(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.8,
                image: CachedNetworkImageProvider(image ?? ""),
                placeholderBuilder: OctoPlaceholder.blurHash('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                errorBuilder: OctoError.icon(color: Colors.red),
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                height: 90,
                width: 90,
                margin: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    File(imagePath!),
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, str, tra) => Icon(Icons.info, color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Your image has been successfully cartoonized. Please save into your phone and share with others.',
              textAlign: TextAlign.center,
              style: GoogleFonts.courgette(textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
            ),
          ),
          Spacer(),
          Container(
            height: 70,
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade400))),
            child: Row(
              children: [
                IconButton(
                  onPressed: shareImage,
                  icon: Icon(Icons.share, color: shareFile.value == '' ? Colors.grey : Theme.of(context).primaryColor),
                ),
                IconButton(
                  onPressed: saveImage,
                  icon: Icon(Icons.save),
                ),
                Spacer(),
                if (imgProgress.value > 0.0 && imgProgress.value < 1.0)
                  CircularPercentIndicator(
                    center: Text(
                      '${(double.parse(imgProgress.value.toString()) * 100).toStringAsFixed(0)} %',
                      style: TextStyle(fontSize: 12),
                    ),
                    radius: 25,
                    animation: true,
                    percent: imgProgress.value,
                    lineWidth: 2,
                    fillColor: Colors.grey.shade200,
                    progressColor: Colors.teal,
                  ),
                SizedBox(width: 4)
              ],
            ),
          )
        ],
      ),
    );
  }

  var shareFile;

  saveImage() async {
    bool storageCheck = await permissionHandler.storagePermission();
    if (storageCheck) {
      var appDir = await getTemporaryDirectory();
      String savePath = appDir.path + '/cartoon.png';
      shareFile.value = savePath;
      await Dio().download(image!, savePath, onReceiveProgress: (count, total) {
        double res = count / total;
        imgProgress.value = res;
      });
      final resle = await ImageGallerySaver.saveFile(savePath).catchError((e) {
        Fluttertoast.showToast(msg: 'Something wrong in saving image.', backgroundColor: Colors.red);
      });
      if (resle != null) {
        Fluttertoast.showToast(msg: 'Successfully saved.', backgroundColor: Colors.teal);
      }
    } else {
      Fluttertoast.showToast(msg: 'You denied storage permission', backgroundColor: Colors.amber, textColor: Colors.black);
    }
  }

  shareImage() async {
    if (shareFile.value == '') {
      Fluttertoast.showToast(msg: 'Please save the photo first.', backgroundColor: Colors.amber, textColor: Colors.black);
    }
    await Share.shareFiles([shareFile.value], text: 'Hi, this is my cartoonize photo, check it out.');
  }
}
