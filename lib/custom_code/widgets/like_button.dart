import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/popups/popup_liked/popup_liked_widget.dart';

import '../../constant.dart';

class LikeButtonWidget extends StatefulWidget {
  final String documentId;
  final bool isActive;
  final double? size;

  const LikeButtonWidget({Key? key, required this.documentId, this.isActive = true, this.size}) : super(key: key);

  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  late bool isLiked;
  late int likesCount;

  @override
  void initState() {
    super.initState();
    isLiked = false;
    likesCount = 0;
    _checkLikeStatus();
  }

  Future<void> _checkLikeStatus() async {
    String currentUserId = await getCurrentUserId();
    final likesRef = await FirebaseFirestore.instance
        .collection('likes')
        .where('liked_by', isEqualTo: currentUserId)
        .where('document_id', isEqualTo: widget.documentId) // Check for likes of this specific document
        .get();
    final likesCountNumber = await FirebaseFirestore.instance
        .collection('likes')
        .where('document_id', isEqualTo: widget.documentId) // Check for likes of this specific document
        .get();

    setState(() {
      isLiked = likesRef.docs.isNotEmpty;
      likesCount = likesCountNumber.docs.length;
    });
  }

  Future<void> _toggleLike() async {
    if (widget.isActive == false) {
      return;
    }

    String currentUserId = await getCurrentUserId();
    if (isLiked) {
      // Query for all 'like' documents by the current user for the current item.
      QuerySnapshot query = await FirebaseFirestore.instance.collection('likes').where('liked_by', isEqualTo: currentUserId).where('document_id', isEqualTo: widget.documentId).get();

      // Delete each 'like' document found by the query.
      for (var doc in query.docs) {
        await doc.reference.delete();
      }
    } else {
      // Add a 'like' document with fields specifying who liked what.
      await FirebaseFirestore.instance.collection('likes').add({
        'liked_by': currentUserId,
        'document_id': widget.documentId,
        'like_time': Timestamp.now(),
      });
    }

    // Update the local state to reflect the new like status.
    setState(() {
      isLiked = !isLiked;
      likesCount += isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        width: widget.size == null ? 80 : 50,
        child: InkWell(
          focusColor: Color(0xFFFFFFFF),
          onTap: _toggleLike,
          onLongPress: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enableDrag: false,
              context: context,
              builder: (bottomSheetContext) {
                return DraggableScrollableSheet(builder: (BuildContext context, ScrollController scrollController) {
                  return GestureDetector(
                    onTap: () => '',
                    child: Padding(padding: MediaQuery.of(bottomSheetContext).viewInsets, child: PopupLikedWidget(documentId: widget.documentId)),
                  );
                });
              },
            ).then((value) => setState(() {}));
          },
          child: Padding(
            padding: EdgeInsets.all(widget.size ?? 15.0),
            child: Row(
              children: [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  color: isLiked ? blueColor : greyColor,
                  size: widget.size ?? 24,
                ),
                SizedBox(width: 8),
                Text(
                  likesCount.toString(),
                  style: TextStyle(
                    fontSize: widget.size ?? 14,
                    color: isLiked ? blueColor : greyColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
