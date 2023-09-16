import 'package:flutter/material.dart';

class AiModelSettingsPage extends StatefulWidget {
  AiModelSettingsPage({super.key});

  bool _isObscured = true;

  @override
  State<AiModelSettingsPage> createState() => _AiModelSettingsPageState();
}

class _AiModelSettingsPageState extends State<AiModelSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(text: """
You're FRF20Bot our company's leads collector & helpful assistant to help customers,

an automated service to collect leads for FRF20 digital marketing, web design, business/WhatsApp automation.

You first greet the customer, then collect their name and email address (required).

You should respond in a very short, conversational, friendly style.

Remember, you must stay on the topic and don't go outside the order topic (required).

Then you must summarize service information that the customer is interested in,

and submit it to Google Sheet automatically

when you understand that you gathered all the required info from the customer by yourself (required).

Respond as succinctly as possible. If you don't know the answer, respond "Sorry, I don't know the answer!".""");

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "OpenAI API Key",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 13),
            TextField(
              obscureText: widget._isObscured,
              decoration: InputDecoration(
                labelText: 'Enter your API key',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      widget._isObscured = !widget._isObscured;
                    });
                  },
                  icon: Icon(widget._isObscured
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'OpenAI API Key',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'To enable seamless communication with the OpenAI API, provide your unique API key. This key allows your application to securely interact with the OpenAI service and enhance the quality of AI responses:\n\n'
              "• Sign up for an OpenAI account if you haven't.\n"
              '• Generate an API key in your OpenAI account settings.\n'
              '• Paste your API key in the field provided.',
              textAlign: TextAlign.start,
            ),
            const Divider(
              color: Colors.grey,
              height: 22,
            ),
            const Text(
              'System Message Requirements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Tailor the AI's initial response by entering a message that sets the tone for customer interactions. This message will be used as the starting point whenever the AI communicates with customers:\n\n"
              "• Personalize the AI's first response.\n"
              '• Create a welcoming or informative intro.\n'
              '• Set the context for customer conversations.',
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 13),
            TextFormField(
              controller: _controller,
              maxLines: null, // Allow multiple lines
              decoration: const InputDecoration(
                labelText: 'Enter system message',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Company Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Feel free to provide your company information for the AI model, especially if customers are curious to learn more about your company:',
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: "Company Name"),
            ),
            const SizedBox(height: 13),
            TextFormField(
              decoration: const InputDecoration(labelText: "Company Email"),
            ),
            const SizedBox(height: 13),
            TextFormField(
              decoration: const InputDecoration(labelText: "Company Address"),
            ),
            const SizedBox(height: 13),
            TextFormField(
              decoration: const InputDecoration(labelText: "Company Website"),
            ),
            const SizedBox(height: 13),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: "Company Linkedin Profile"),
            ),
            const SizedBox(height: 13),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: "Company Youtube Channel"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Save Changes"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
