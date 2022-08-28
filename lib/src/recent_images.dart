import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartoonize/app_utils/own_permission.dart';
import 'package:cartoonize/local_db/file_model.dart';
import 'package:cartoonize/local_db/local_db.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class RecentImages extends StatefulWidget {
  const RecentImages({Key? key}) : super(key: key);

  @override
  State<RecentImages> createState() => _RecentImagesState();
}

class _RecentImagesState extends State<RecentImages> {
  late ValueNotifier<List<ImgFile>> imgs;
  OwnPermissionHandler permissionHandler = OwnPermissionHandler();

  refreshImages() async {
    imgs.value = await LocalDatabase.instance.getAllImages();
  }

  @override
  void initState() {
    super.initState();
    permissionHandler.storagePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Images'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: FutureBuilder<List<ImgFile>>(
          future: LocalDatabase.instance.getAllImages(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              imgs = ValueNotifier<List<ImgFile>>(snapshot.data!);
              if (imgs.value.isNotEmpty) {
                return ValueListenableBuilder<List<ImgFile>>(
                    valueListenable: imgs,
                    builder: (context, images, child) {
                      return MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              CachedNetworkImage(
                                imageUrl: images[index].imageUrl ?? "",
                                placeholder: (context, str) => Icon(Icons.image),
                                errorWidget: (context, str, tra) => Icon(Icons.info, color: Colors.grey),
                              ),
                              PopupMenuButton(
                                  padding: EdgeInsets.all(2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  onSelected: (s) {
                                    if (s == 1) {
                                      saveDialog(context, images[index].imageUrl!);
                                    } else {
                                      deleteDialog(context, images[index].id!);
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        child: Icon(Icons.download),
                                        value: 1,
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Icon(
                                          Icons.delete_rounded,
                                          color: Colors.redAccent,
                                        ),
                                        onTap: () {
                                          print('hi');
                                        },
                                      ),
                                    ];
                                  })
                            ],
                          );
                        },
                      );
                    });
              } else {
                return Center(child: Text('[]'));
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  deleteDialog(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Icon(Icons.delete, color: Colors.redAccent),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            titlePadding: EdgeInsets.symmetric(vertical: 4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Text('Are you sure want to delete this photo?'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                    TextButton(
                      onPressed: () async {
                        await LocalDatabase.instance.delete(id);

                        refreshImages();
                        Navigator.of(context).pop();
                      },
                      child: Text('Yes', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  saveDialog(BuildContext context, String url) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Icon(Icons.download, color: Colors.teal),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            titlePadding: EdgeInsets.symmetric(vertical: 4),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Text('Are you sure want to save this photo?'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                    TextButton(
                      onPressed: () async {
                        saveImage(url);
                        Navigator.of(context).pop();
                      },
                      child: Text('Yes'),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  saveImage(String image) async {
    bool storageCheck = await permissionHandler.storagePermission();
    if (storageCheck) {
      var appDir = await getTemporaryDirectory();
      String savePath = appDir.path + '/cartoon.png';
      await Dio().download(image, savePath, onReceiveProgress: (count, total) {
        double res = count / total;
        // imgProgress.value = res;
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
