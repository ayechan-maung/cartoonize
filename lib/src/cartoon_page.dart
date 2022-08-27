import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartoonize/app_utils/own_permission.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:octo_image/octo_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CartoonPage extends HookWidget {
  final String? image;
  CartoonPage({Key? key, this.image}) : super(key: key);

  var imgProgress;
  OwnPermissionHandler permissionHandler = OwnPermissionHandler();

  @override
  Widget build(BuildContext context) {
    imgProgress = useState(0.0);

    useEffect(() {
      permissionHandler.storagePermission();
      return () {};
    }, []);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          OctoImage(
            height: MediaQuery.of(context).size.height - 180,
            image: CachedNetworkImageProvider(image ?? ""),
            placeholderBuilder: OctoPlaceholder.blurHash('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
            errorBuilder: OctoError.icon(color: Colors.red),
            fit: BoxFit.cover,
          ),
          Spacer(),
          Container(
            height: 70,
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade400))),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {},
                  icon: Icon(Icons.share),
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

  saveImage() async {
    bool storageCheck = await permissionHandler.storagePermission();
    if (storageCheck) {
      var appDir = await getTemporaryDirectory();
      String savePath = appDir.path + '/cartoon.png';
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
}
