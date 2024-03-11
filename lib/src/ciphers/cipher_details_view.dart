import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

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
  late String _resultText;
  bool _isEncryptMode = true; // Default mode is encryption
  bool _isTextMode = true; // Default input mode is text

  @override
  void initState() {
    super.initState();
    _inputTextController = TextEditingController();
    _resultText = '';
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  Future<void> _processData() async {
    if (_isTextMode) {
      // Text input mode
      String inputText = _inputTextController.text;
      // Perform encryption or decryption based on selected mode
      _resultText =
          _isEncryptMode ? encryptText(inputText) : decryptText(inputText);
    } else {
      // File input mode
      // Read file contents
      String fileContents = await _readFile();
      // Perform encryption or decryption based on selected mode
      _resultText = _isEncryptMode
          ? encryptText(fileContents)
          : decryptText(fileContents);
    }

    setState(() {});
  }

  String encryptText(String input) {
    // Implement your encryption logic here
    return input;
  }

  String decryptText(String input) {
    // Implement your decryption logic here
    return input;
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
                    decoration: const InputDecoration(
                      labelText: 'Input Text',
                    ),
                  )
                : const SizedBox(), // Hide text input when file mode is selected
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _processData,
              child: Text(_isEncryptMode ? 'Encrypt' : 'Decrypt'),
            ),
            const SizedBox(height: 16),
            const Text('Result:'),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_resultText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
