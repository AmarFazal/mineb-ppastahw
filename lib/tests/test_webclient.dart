// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:whatsapp_agent_android/config/config.dart';
//
// void main() {
//   late IO.Socket socket;
//
//   socket = IO.io(BASE_DOMAIN, <String, dynamic>{
//     'transports': ['websocket'],
//   });
//
//   socket.on('new_message_app', (data) {
//     print('Yeni mesaj alındı:');
//     print('Message: ${data['message']}');
//     print('Phone Number: ${data['from_number']}');
//     print('Time Stamp: ${data['timestamp']}');
//     //print('All Data: ${data}');
//   });
//
//   socket.on('connect', (_) {
//     print('Connected to server');
//   });
// }
//
//
// // socket.emit('join_in_app', {'from_number': 447883250480});
// // import 'package:socket_io_client/socket_io_client.dart' as IO;
// //
// // void main() {
// //   late IO.Socket socket;
// //
// //   socket = IO.io('BASE_DOMAIN', <String, dynamic>{
// //     'transports': ['websocket'],
// //   });
// //   socket.on('connect', (_) {
// //     print('Connected to server');
// //   });
// //
// //   socket.emit(
// //       'join', {'from_number': 447883250480}); // No quotes around the number
// //
// //   socket.on('server_response', (data) => print('Server Response: ${data['data']}'));
// //   socket.on('new_message', (data) => print('New message: ${data['message']}'));
// // }
//
// //ayri
// // socket.on('message', (data) {
// //   print('Joined room: ${data['data']}');
// // });
//
// //socket.emit('connect', {'room': 447883250480});
//
// // socket.on('server_response', (data) => print('Server Response: ${data['data']}'));