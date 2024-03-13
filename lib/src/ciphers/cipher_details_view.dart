import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modified_cipher/src/method/rc4.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

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
  late String _fileType;
  bool _isEncryptMode = true;
  bool _isTextMode = true;

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
    String inputText = _inputTextController.text;
    _resultText = _isEncryptMode
        ? encryptText(inputText, key)
        : decryptText(inputText, key);

    setState(() {});
  }

  String encryptText(String input, String key) {
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

      List<int> inputBytes = base64Decode(input);

      RC4 rc4 = RC4(keyBytes);
      List<int> decryptedBytes = rc4.decrypt(inputBytes);

      return String.fromCharCodes(decryptedBytes);
    }

    return '';
  }

  Future<String> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      _fileType = result.files.single.extension!;
      List<int> fileBytes = await file.readAsBytes();
      String fileContents = String.fromCharCodes(fileBytes);
      return fileContents;
    } else {
      return '';
    }
  }

  Future<void> _saveToFile() async {
    try {
      final Directory directory = Directory('/storage/emulated/0/Download/');
      final File file = File('${directory.path}/result.$_fileType');

      await file.writeAsString(_resultText,
          mode: FileMode.write, encoding: utf8);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save file: $e')),
      );
    }
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
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          String fileContents = await _pickFile();
                          _inputTextController.text = fileContents;
                        },
                        child: const Text('Choose File'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _inputTextController,
                        decoration: const InputDecoration(
                          labelText: 'File Contents',
                        ),
                        readOnly: true,
                      ),
                    ],
                  ), // Hide text input when file mode is selected
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveToFile,
              child: const Text('Download'),
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
