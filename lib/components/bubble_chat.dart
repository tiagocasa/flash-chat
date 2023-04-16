import 'package:flutter/material.dart';

class MyMessageBubble extends StatelessWidget {
  const MyMessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.isMe,
      required this.isLastSender});

  final String sender;
  final String text;
  final bool isMe;
  final bool isLastSender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: !isLastSender
          ? const EdgeInsets.all(5.0)
          : const EdgeInsets.only(left: 5.0, top: 0.0, right: 5.0, bottom: 5.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: isLastSender
            ? [
                Material(
                  borderRadius: isMe
                      ? isLastSender
                          ? BorderRadius.circular(30.0)
                          : const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            )
                      : isLastSender
                          ? BorderRadius.circular(30.0)
                          : const BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                  elevation: 3.0,
                  color: isMe ? Colors.lightBlueAccent : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black54,
                          fontSize: 15),
                    ),
                  ),
                ),
              ]
            : [
                Text(
                  isMe ? '' : sender,
                  style: const TextStyle(fontSize: 10.0, color: Colors.black),
                ),
                Material(
                  borderRadius: isMe
                      ? isLastSender
                          ? BorderRadius.circular(30.0)
                          : const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            )
                      : isLastSender
                          ? BorderRadius.circular(30.0)
                          : const BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                  elevation: 3.0,
                  color: isMe ? Colors.lightBlueAccent : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black54,
                          fontSize: 15),
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
