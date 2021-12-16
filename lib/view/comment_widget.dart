import 'package:findgamemates/model/game_comment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatefulWidget {

  GameComment gameComment;

  CommentWidget({Key? key, required this.gameComment}) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  late String date;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.gameComment.senderName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.gameComment.comment
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
              alignment: Alignment.bottomRight,
              child: Text(
                //todo: check local date time
                DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(widget.gameComment.sendTime).toLocal()),
                style: const TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
