import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modified_cipher/src/method/rc4.dart';

class CipherDetailsView extends StatefulWidget {
  final String title;
  final String description;

  const CipherDetailsView({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _CipherDetailsViewState createState() => _CipherDetailsViewState();
}

class _CipherDetailsViewState extends State<CipherDetailsView> {
  late TextEditingController _inputTextController;
  late TextEditingController _keyTextController;
  late String _resultText;
  bool _isEncryptMode = true; // Default mode is encryption
  bool _isTextMode = true; // Default input mode is text

  @override
  void initState() {
    super.initState();
    _inputTextController = TextEditingController();
    _keyTextController = TextEditingController();
    _resultText = '';
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    _keyTextController.dispose();
    super.dispose();
  }

  Future<void> _processData() async {
    String key = _keyTextController.text;
    if (_isTextMode) {
      // Text input mode
      String inputText = _inputTextController.text;
      // Perform encryption or decryption based on selected mode
      _resultText = _isEncryptMode
          ? encryptText(inputText, key)
          : decryptText(inputText, key);
    } else {
      // File input mode
      // Read file contents
      String fileContents = await _readFile();
      // Perform encryption or decryption based on selected mode
      // _resultText = _isEncryptMode
      //     ? encryptText(fileContents, key)
      //     : decryptText(fileContents, key);
    }

    setState(() {});
  }

  String encryptText(String input, String key) {
    // Implement your encryption logic here
    if (key.isNotEmpty && input.isNotEmpty) {
      List<int> keyBytes = key.codeUnits;
      List<int> inputBytes = input.codeUnits;

      RC4 rc4 = RC4(keyBytes);
      List<int> resultBytes = rc4.encrypt(inputBytes);
      String base64 = base64Encode(resultBytes);
      return base64;
    }
    return "Please enter a valid key and input text";
  }

  String decryptText(String input, String key) {
    if (input.isNotEmpty && key.isNotEmpty) {
      List<int> keyBytes = key.codeUnits;

      // Decode Base64 input
      List<int> inputBytes = base64Decode(input);

      RC4 rc4 = RC4(keyBytes);
      List<int> decryptedBytes = rc4.decrypt(inputBytes);

      return String.fromCharCodes(decryptedBytes);
    }

    return '';
  }

  Future<String> _readFile() async {
    // Implement file selection logic here
    return ''; // Return file contents as a string
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<bool>(
                  value: _isEncryptMode,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        _isEncryptMode = value;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Encrypt'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Decrypt'),
                    ),
                  ],
                ),
                DropdownButton<bool>(
                  value: _isTextMode,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        _isTextMode = value;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Text'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('File'),
                    ),
                  ],
                ),
              ],
            ),
            _isTextMode
                ? TextField(
                    controller: _inputTextController,
                    decoration: InputDecoration(
                      labelText: _isEncryptMode
                          ? 'Plain text'
                          : 'Cipher text (base 64)', // Change label based on input mode
                    ),
                  )
                : const SizedBox(), // Hide text input when file mode is selected
            const SizedBox(height: 16),
            TextField(
              controller: _keyTextController,
              decoration: const InputDecoration(
                labelText: 'Key',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _processData,
              child: Text(_isEncryptMode ? 'Encrypt' : 'Decrypt'),
            ),
            const SizedBox(height: 16),
            const Text('Result:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_resultText),
              ),
            ),
            // const SizedBox(height: 16),
            // const Text('Base 64:',
            //     style: TextStyle(fontWeight: FontWeight.bold)),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Text(_resultBase64),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
