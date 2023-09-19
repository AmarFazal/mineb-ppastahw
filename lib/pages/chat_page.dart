import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_agent_android/widgets/message_box/image_message.dart';
import 'package:whatsapp_agent_android/widgets/snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../1frf_api.dart';
import '../config/config.dart';
import '../utilities/colors.dart';
import '../widgets/dialog.dart';
import '../widgets/message_box/agent_message.dart';
import '../widgets/message_box/assistant_message.dart';
import '../widgets/message_box/user_audio_message.dart';
import '../widgets/message_box/user_document_message.dart';
import '../widgets/message_box/user_image_message.dart';
import '../widgets/message_box/user_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http_parser/http_parser.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.phoneNumber});

  final int phoneNumber;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> chatHistory = [];
  final ScrollController _scrollController = ScrollController();
  late IO.Socket socket;
  int AssignedAgentId = 0;
  bool isProcessing = false;

  Future<int?> _getAgentId() async {
    int? agentId = await GetId.getAgentId();
    return agentId;
  }

  Future<void> requestGalleryPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      // İzin verildi, galeriye erişim sağlanabilir
    } else {
      // İzin reddedildi veya bekleniyor, kullanıcıyı bilgilendirin
    }
  }

  @override
  void initState() {
    super.initState();
    requestGalleryPermission();
    socket = IO.io(TEST_DOMAIN, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on('new_message_app', (data) {
      if (kDebugMode) {
        print('Yeni mesaj alındı:');
        print('Message: ${data['message']}');
        print('Phone Number: ${data['from_number']}');
        print('Time Stamp: ${data['timestamp']}');
      }
      // Yeni mesajı chatHistory listesine ekleyin ve ekranda gösterin

      if (data['from_number'].toString() == widget.phoneNumber.toString()) {
        setState(() {
          chatHistory.add({
            "role": 'user',
            "timestamp": data['timestamp'],
            "content": data['message'],
          });

          // ListView'i en son içeriğe kaydırın.
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }

      socket.on('connect', (_) {
        if (kDebugMode) {
          print('Connected to server');
        }
      });
    });
    getChatFunction(widget.phoneNumber);
  }

  Future<void> getChatFunction(phoneNumber) async {
    // Yeni API endpoint'ini kullanarak verileri çekin
    int? agentId = await _getAgentId();
    var headers = {'Content-Type': 'application/json', 'X-API-Key': API_KEY};
    var request = http.Request(
      'GET',
      Uri.parse(
          '$TEST_DOMAIN${API_ENDPOINT}chat/${widget.phoneNumber}/$agentId'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      phoneNumberClicked = widget.phoneNumber;
      final chatData = json.decode(await response.stream.bytesToString());

      // Verileri yeni API formatına göre ayrıştırın
      // chatHistory'yi güncelleyin
      setState(() {
        chatHistory = List.from(chatData["history"]["context"]);
      });

      // AssignedAgentId'yi güncelleyin (gerekirse)
      AssignedAgentId = chatData['history']['assigned_to_agent_id'];

      // ListView'i en son içeriğe kaydırın.
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  int phoneNumberClicked = 0123456789;

  void _sendMessage() async {
    int? agentId = await _getAgentId();

    if (_messageController.text.isNotEmpty) {
      // Mesaj kutusunu ekleyin
      setState(() {
        chatHistory.add({
          "role": 'agent',
          "agent_id": agentId,
          "timestamp": DateTime.now().toIso8601String(),
          "content": _messageController.text,
        });
      });

      // Bekleme göstergesini gösterin
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        // Kullanıcının dışarı tıklayarak kapatmasını önleyin
        builder: (BuildContext context) {
          return const Center(
              child: SpinKitDoubleBounce(
                  color: CustomColors.accentColor, size: 50.0));
        },
      );

      // Mesajı API'ye gönderin ve API yanıtını bekleyin
      var headers = {
        'Content-Type': 'application/json',
        'X-API-Key': API_KEY,
        'Cookie': 'session=...'
      };

      var request = http.Request(
          'POST',
          Uri.parse(
              '$TEST_DOMAIN${API_ENDPOINT}chat/$phoneNumberClicked/$agentId'));
      request.body = json.encode({"message": _messageController.text});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        if (kDebugMode) {
          print(responseString);
        }

        // API yanıtı geldiğinde mesaj kutusunu temizleyin
        setState(() {
          _messageController.clear();
        });

        // Bekleme göstergesini kapatın
        Navigator.of(context).pop();

        // Scroll işlemini yapabilirsiniz
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        showErrorDialog(context, 'Something went wrong.');
        Navigator.of(context).pop();
      }
    } else {
      MySnackBar(context, 'Write The Message You Want Send');
    }
  }

  Future<void> _refreshChat() async {
    await getChatFunction(phoneNumberClicked);
  }

  void assignToAi() async {
    int? agentId = await _getAgentId();
    var headers = {'Content-Type': 'application/json', 'X-API-Key': API_KEY};
    var request = http.Request(
        'POST',
        Uri.parse(
            '$TEST_DOMAIN${API_ENDPOINT}chat/${widget.phoneNumber}/$agentId'));
    request.body = json.encode({"assign_ai": "True"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> responseJson = json.decode(responseBody);

    if (mounted) {
      if (response.statusCode == 200) {
        String message = responseJson["msg"];
        MySnackBar(context, message);
      } else {
        MySnackBar(context, "Please Try Again Later.");
      }
    }
  }

  Future<void> uploadImageToWhatsApp(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://a59e-94-123-201-158.ngrok-free.app/send_image'), // Replace with your server's URL
    );

    var file = http.MultipartFile.fromBytes(
      'file',
      imageFile.readAsBytesSync(),
      filename: 'image.png',
      contentType: MediaType('image', 'png'),
    );

    request.files.add(file);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded to WhatsApp successfully');
      print('Image ID: ${response.statusCode}');
    } else {
      print('Failed to upload image to WhatsApp');
    }
  }

  Future<File?> getImageFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Değişiklik burada
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await getChatFunction(phoneNumberClicked);
        bool shouldPop = false;
        if (AssignedAgentId != 0) {
          shouldPop = (await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Attention!'),
                content: const Text(
                    'Do you want to assign this customer to AI Auto-reply system'),
                actions: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            assignToAi();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ))!;
        } else {
          Navigator.pop(context);
        }
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          title: Text("+$phoneNumberClicked"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshChat,
            ),
            IconButton(
              onPressed: isProcessing
                  ? null // Eğer işlem devam ediyorsa, onPressed null olmalıdır
                  : () {
                      // Düğmeye tıklanınca işlem başlasın
                      getChatFunction(phoneNumberClicked);
                      setState(() {
                        isProcessing = true;
                      });

                      // 3 saniye gecikmeli işlem
                      Future.delayed(const Duration(seconds: 3), () {
                        // İşlem tamamlandığında burada kodu çalıştırabilirsiniz.
                        // Örneğin, bir işlem tamamlandığında bir mesaj göstermek için:
                        setState(() {
                          isProcessing = false;
                        });

                        // İşlem sonrası yapılacak işlemleri burada ekleyebilirsiniz.

                        if (AssignedAgentId != 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Warning'),
                                content: const Text(
                                    'Are You Sure To Assign This User To Ai'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      assignToAi();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          MySnackBar(
                              context, "This Customer Is Already Assign To Ai");
                        }
                      });
                    },
              icon: isProcessing
                  ? const SpinKitFadingCircle(
                      size: 35,
                      color: Colors.white,
                    )
                  : const Icon(Icons.link_off),
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _refreshChat,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) => buildMessageWidget(
                      chatHistory[chatHistory.length - index - 1],
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type a message...',
                                  contentPadding: EdgeInsets.zero),
                            ),
                          ),
                        ),
                        IconButton(
                          style: IconButton.styleFrom(padding: EdgeInsets.zero),
                          icon: const Icon(Icons.image),
                          onPressed: () async {
                            final imageFile = await getImageFile();
                            if (imageFile != null) {
                              int? agentId = await _getAgentId();
                              setState(() {
                                chatHistory.add({
                                  "role": 'agent',
                                  "agent_id": agentId,
                                  "timestamp": DateTime.now().toIso8601String(),
                                  "content":
                                      ImageMessageWidget(imageFile: imageFile),
                                });
                              });
                              await uploadImageToWhatsApp(imageFile);
                            }
                          },
                        ),
                        IconButton(
                          style: IconButton.styleFrom(padding: EdgeInsets.zero),
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            _sendMessage();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMessageWidget(Map<String, dynamic> message) {
    switch (message["role"]) {
      case 'user':
        return buildUserMessageWidget(message);
      case 'assistant':
        return buildAssistantMessageWidget(message);
      case 'agent':
        return buildAgentMessageWidget(message);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildUserMessageWidget(Map<String, dynamic> message) {
    final messageRole = message['role'];
    final messageType = message['messages']['type'];
    final timestamp = message['messages']['timestamp'];

    if (messageType == 'text') {
      return UserMessage(
        message: {
          "role": messageRole,
          "content": message["messages"]["content"],
          "timestamp": timestamp,
        },
      );
    } else if (messageType == 'image') {
      return UserImageMessageWidget(
        message: {
          "role": messageRole,
          "timestamp": timestamp,
        },
        imageID: message["messages"]['gdrive_img_id'],
      );
    } else if (messageType == 'document') {
      return UserDocumentMessageWidget(
        documentID: message["messages"]["gdrive_img_id"],
        message: {
          "role": messageRole,
          "timestamp": timestamp,
          "type": messageType,
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildAssistantMessageWidget(Map<String, dynamic> message) {
    return AssistantMessage(
      message: {
        "role": message['role'],
        "content": message["messages"]["content"],
        "timestamp": message["messages"]["timestamp"],
      },
    );
  }

  Widget buildAgentMessageWidget(Map<String, dynamic> message) {
    return AgentMessage(message: message);
  }
}
