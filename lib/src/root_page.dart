import 'dart:io';

import 'package:cartoonize/local_db/file_model.dart';
import 'package:cartoonize/local_db/local_db.dart';
import 'package:cartoonize/logic/bloc.dart';
import 'package:cartoonize/service/snapshot_response.dart';
import 'package:cartoonize/src/cartoon_page.dart';
import 'package:cartoonize/src/recent_images.dart';
import 'package:cartoonize/src/slider_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:photo_view/photo_view.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  ImagePicker imgPicker = ImagePicker();
  XFile? file;

  Bloc bloc = Bloc();
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();
  final pvController = PhotoViewController();

  _storeImage(String image) {
    final img = ImgFile(imageUrl: image, dateTime: DateTime.now(), description: '');

    LocalDatabase.instance.storeImage(img);
  }

  @override
  void initState() {
    super.initState();

    bloc.mvStream().listen((snapshot) {
      if (snapshot.hasData) {
        // SnapshotResponse snap = snapshot.data!;
        Map<String, dynamic>? data = snapshot.data;

        _storeImage(data!['image_url']);

        Fluttertoast.showToast(msg: 'Your image generated successfully to cartoonize.', backgroundColor: Colors.teal);
        Navigator.push(
          key.currentContext!,
          MaterialPageRoute(
            builder: (context) => CartoonPage(
              image: data['image_url'],
              imagePath: file!.path,
            ),
          ),
        );
      }
    });
  }

  Future<File> cropImg(File file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 95,
      // aspectRatioPresets: [CropAspectRatioPreset.original, CropAspectRatioPreset.ratio3x2,CropAspectRatioPreset.],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.transparent,
            toolbarWidgetColor: Colors.grey.shade800,
            initAspectRatio: CropAspectRatioPreset.original,
            backgroundColor: Colors.grey.shade200,
            activeControlsWidgetColor: Colors.teal,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Cropper', aspectRatioLockEnabled: false),
      ],
    );
    return File(croppedFile!.path);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: key,
      body: NestedScrollView(
        headerSliverBuilder: (context, b) {
          return [
            SliverAppBar(
              elevation: 0,
              stretch: true,
              primary: true,
              pinned: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecentImages()));
                },
                icon: Icon(Icons.list),
              ),
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Cartoonize',
                  style: GoogleFonts.kalam(textStyle: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            )
          ];
        },
        body: StreamBuilder<SnapshotResponse>(
          stream: bloc.mvStream(),
          initialData: SnapshotResponse(data: null),
          builder: (context, snapshot) {
            SnapshotResponse snap = snapshot.data!;
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    if (file == null)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SliderWidget(imgList: [
                              imgWidget(context, 'images/evan.jpeg'),
                              imgWidget(context, 'images/hormworth.jpeg'),
                              imgWidget(context, 'images/she.jpeg'),
                              imgWidget(context, 'images/she2.webp'),
                            ]),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Let\'s get the photo of yours to cartoon,',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pacifico(
                                    textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                              ),
                            ),
                            Text(
                              'have fun!',
                              style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                            )
                          ],
                        ),
                      ),
                    if (file != null)
                      Expanded(
                        child: Column(
                          children: [
                            Stack(
                              fit: StackFit.passthrough,
                              alignment: Alignment.topRight,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: size.height * 0.6,
                                    width: size.width * 0.7,
                                    child: PhotoView(
                                      controller: pvController,
                                      imageProvider: FileImage(
                                        File(file!.path),
                                        // width: size.width * 0.8,
                                        // height: size.height * 0.7,
                                        // fit: BoxFit.cover,
                                      ),
                                      backgroundDecoration: BoxDecoration(color: Colors.grey.shade200),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.4)),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        file = null;
                                      });
                                    },
                                    padding: EdgeInsets.all(4),
                                    constraints: BoxConstraints(),
                                    icon: Icon(CupertinoIcons.clear, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Upload your photo to get amazing cartoon image.',
                              style: GoogleFonts.slabo27px(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                            )
                          ],
                        ),
                      ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade400))),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              file = await imgPicker.pickImage(source: ImageSource.camera);

                              setState(() {});
                            },
                            icon: Icon(Icons.camera_alt_rounded),
                          ),
                          IconButton(
                            onPressed: () async {
                              file = await imgPicker.pickImage(source: ImageSource.gallery);

                              setState(() {});
                            },
                            icon: Icon(Icons.image),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (file == null) {
                                Fluttertoast.showToast(
                                  msg: 'Please pick the image first.',
                                  backgroundColor: Colors.amber,
                                  textColor: Colors.black,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              } else {
                                File f = await cropImg(File(file!.path));
                                file = XFile(f.path);
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.crop, color: file == null ? Colors.grey : Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                if (snap.status == Status.loading)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.5),
                    child: SizedBox(
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<double>(
                                stream: bloc.progressStream(),
                                initialData: 0.0,
                                builder: (context, snapshot) {
                                  // if (snapshot.hasData) {
                                  double progress = snapshot.data!;

                                  // if (progress != 1.0)
                                  return LinearPercentIndicator(
                                    backgroundColor: Colors.white,
                                    percent: progress,
                                    lineHeight: 20,
                                    width: 200,
                                    barRadius: Radius.circular(12),
                                    linearGradient: LinearGradient(
                                      colors: [Colors.teal.shade200, Colors.teal.shade300, Colors.teal.shade400, Colors.teal],
                                    ),
                                    animation: true,
                                    alignment: MainAxisAlignment.center,
                                    center: Text(
                                      '${(progress * 100).toStringAsFixed(0)} %',
                                      style: TextStyle(color: progress > .7 ? Colors.white : Colors.black),
                                    ),
                                  );
                                }),
                            Text('Processing...', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
      floatingActionButton: StreamBuilder<SnapshotResponse>(
          stream: bloc.mvStream(),
          initialData: SnapshotResponse(),
          builder: (context, snapshot) {
            SnapshotResponse? snapData = snapshot.data;
            return FloatingActionButton(
              onPressed: file == null
                  ? null
                  : () async {
                      Map<String, dynamic> m = {};
                      if (file != null) {
                        m['file'] = await MultipartFile.fromFile(file!.path, filename: basename(file!.path));
                        // print(form.fields.toString());
                      }
                      FormData form = FormData.fromMap(m);
                      if (snapData!.status == Status.loading) {
                        bloc.cancelRequest();
                      } else {
                        bloc.getMv(fd: form);
                      }
                    },
              child: Icon(snapData!.status == Status.loading ? Icons.cancel : Icons.upload),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            );
          }),
    );
  }

  Widget imgWidget(BuildContext context, String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        path,
        width: MediaQuery.of(context).size.width * 0.6,
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
