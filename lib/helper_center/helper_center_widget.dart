import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/custom_code/widgets/VideoPlayer.dart';
import 'package:video_player/video_player.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centre d\'aide'),
        backgroundColor: blueColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('centre_daide').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune donnée trouvée'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot doc = snapshot.data!.docs[index];
              final String title = doc['title'];
              final String description = doc['description'];
              final List<dynamic> medias = doc['medias'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text(description),
                    onTap: () {
                      // Naviguer vers une nouvelle page pour afficher les vidéos
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VideoPage(medias, title)),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPage extends StatelessWidget {
  final List<dynamic> videos;
  final String title;

  VideoPage(this.videos, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: blueColor,
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return Container(width: double.infinity ,child: VideoPlayerWidget(videoUrl: videos[index]));
        },
      ),
    );
  }
}
