import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modified_cipher/src/method/rc4.dart';
import 'package:modified_cipher/src/settings/settings_view.dart';

class CipherDetailsView extends StatefulWidget {
  const CipherDetailsView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  _CipherDetailsViewState createState() => _CipherDetailsViewState();
}

class _CipherDetailsViewState extends State<CipherDetailsView> {
  late TextEditingController _inputTextController;
  late TextEditingController _keyTextController;
  late String _resultText;
  late String _fileType = 'txt';
  late List<int> _fileInput;
  late List<int> _fileOutput;
  bool _isEncryptMode = true;
  bool _isTextMode = true;

  @override
  void initState() {
    super.initState();
    _inputTextController = TextEditingController();
    _keyTextController = TextEditingController();
    _resultText = '';
    _fileInput = [];
    _fileOutput = [];
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
    if (_isTextMode) {
      _resultText = _isEncryptMode
          ? encryptText(inputText, key)
          : decryptText(inputText, key);
    } else {
      _resultText = _isEncryptMode ? encryptFile(key) : decryptFile(key);
    }

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

  String encryptFile(String key) {
    if (key.isNotEmpty && _fileInput.isNotEmpty) {
      List<int> keyBytes = key.codeUnits;
      RC4 rc4 = RC4(keyBytes);
      List<int> resultBytes = rc4.encrypt(_fileInput);
      _fileOutput = resultBytes;
      return base64Encode(resultBytes);
    }
    return "Please enter a valid key and input text";
  }

  String decryptFile(String key) {
    if (_fileInput.isNotEmpty && key.isNotEmpty) {
      List<int> keyBytes = key.codeUnits;

      RC4 rc4 = RC4(keyBytes);
      List<int> decryptedBytes = rc4.decrypt(_fileInput);
      _fileOutput = decryptedBytes;
      return base64Encode(decryptedBytes);
    }

    return "Please enter a valid key and input text";
  }

  Future<String> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      _fileType = result.files.single.extension!;
      List<int> fileBytes = await file.readAsBytes();
      _fileInput = fileBytes;
      return file.path.split('/').last;
    } else {
      return '';
    }
  }

  Future<void> _saveToFile() async {
    try {
      final Directory directory = Directory('/storage/emulated/0/Download/');
      final File file = File(
          '${directory.path}/result_${DateTime.now().millisecondsSinceEpoch}.$_fileType');

      if (_isTextMode) {
        await file.writeAsString(_resultText,
            mode: FileMode.write, encoding: utf8);
      } else {
        await file.writeAsBytes(_fileOutput, mode: FileMode.write);
      }

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
        title: const Text('Extended Vigenere Cipher & RC4'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
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
                        _fileType = '.txt';
                        _fileInput = [];
                        _fileOutput = [];
                        _inputTextController.clear();
                        _resultText = '';
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
            const SizedBox(height: 8),
            _isTextMode
                ? TextField(
                    controller: _inputTextController,
                    decoration: InputDecoration(
                      labelText: _isEncryptMode
                          ? 'Plain text'
                          : 'Cipher text (base 64)',
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
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: 'File Contents',
                        ),
                        readOnly: true,
                      ),
                    ],
                  ),
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
            ElevatedButton(
              onPressed: _saveToFile,
              child: const Text('Download'),
            ),
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
