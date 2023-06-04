import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant.dart';

class LikeButtonWidget extends StatefulWidget {
  final String documentId;
  final String userId;

  const LikeButtonWidget({
    Key? key,
    required this.documentId,
    required this.userId,
  }) : super(key: key);

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
    final userLikesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('likes')
        .doc(widget.documentId)
        .get();

    final pharmacyLikesSnapshot = await FirebaseFirestore.instance
        .collection('pharmacies')
        .doc(widget.documentId)
        .get();

    setState(() {
      isLiked = userLikesSnapshot.exists && pharmacyLikesSnapshot.exists;
      likesCount = pharmacyLikesSnapshot.get('likes') ?? 0;
    });
  }

  Future<void> _toggleLike() async {
    final userLikesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('likes')
        .doc(widget.documentId);

    final pharmacyRef = FirebaseFirestore.instance
        .collection('pharmacies')
        .doc(widget.documentId);

    final batch = FirebaseFirestore.instance.batch();

    if (isLiked) {
      batch.delete(userLikesRef);
      batch.update(pharmacyRef, {'likes': FieldValue.increment(-1)});
    } else {
      batch.set(userLikesRef, <String, dynamic>{});
      batch.update(pharmacyRef, {'likes': FieldValue.increment(1)});
    }

    await batch.commit();

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
        width: 90,
        child: InkWell(
          focusColor: Color(0xFFFFFFFF),
          onTap: _toggleLike,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/Like.svg',
                  width: 22,
                  colorFilter: ColorFilter.mode(
                    isLiked ? blueColor : greyColor, BlendMode.srcIn),
                ),
                SizedBox(width: 8),
                Text(
                  likesCount.toString(),
                  style: TextStyle(
                    fontSize: 14,
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
