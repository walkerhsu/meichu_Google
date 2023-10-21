import 'package:flutter/material.dart';

 class ChatBoxMessages extends StatefulWidget {
   const ChatBoxMessages({super.key});

   @override
   State<ChatBoxMessages> createState() => _ChatBoxMessagesState();
 }

 class _ChatBoxMessagesState extends State<ChatBoxMessages> {
   static const List<Map<dynamic, dynamic>> _listMessages = [
     {'received': true, 'message': 'I am here'},
     {'received': false, 'message': 'I am here'},
     {'received': true, 'message': 'I am here'},
     {'received': true, 'message': 'I am here'},
     {'received': false, 'message': 'I am here'},
     {'received': false, 'message': 'I am here'},
   ];

   @override
   Widget build(BuildContext context) {
     return Column(
         children: _listMessages
             .map((message) => Column(
                   children: [
                     const SizedBox(height: 6),
                     Row(
                       mainAxisAlignment: message['received']
                           ? MainAxisAlignment.start
                           : MainAxisAlignment.end,
                       children: [
                         message['received']
                             ? const CircleAvatar(
                                 radius: 12,
                               )
                             : const SizedBox(width: 0),
                         message['received']
                             ? const SizedBox(width: 8)
                             : const SizedBox(width: 0),
                         Text(
                           message['message'],
                           style: TextStyle(
                             backgroundColor: message['received']
                                 ? Colors.blue
                                 : Colors.green,
                           ),
                         ),
                       ],
                     ),
                   ],
                 ))
             .toList());
   }
 }