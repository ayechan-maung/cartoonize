import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartoonize/firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:octo_image/octo_image.dart';

class RecentList extends StatelessWidget {
  RecentList({Key? key}) : super(key: key);

  FirebaseService firebase = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebase.collections,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isNotEmpty) {
            return MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: OctoImage(
                    image: CachedNetworkImageProvider(snapshot.data!.docs[index]['image_url'] ?? ""),
                    placeholderBuilder: OctoPlaceholder.blurHash('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                    errorBuilder: OctoError.icon(color: Colors.red),
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
            // return ListView(
            //   children: snapshot.data!.docs.map((e) => Image.network(e['image_url'] ?? "")).toList(),
            // );
          } else {
            return Center(
              child: Text('You don\'t have recent list.'),
            );
          }
        },
      ),
    );
  }
}
