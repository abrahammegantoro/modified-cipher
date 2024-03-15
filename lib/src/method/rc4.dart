class RC4 {
  final List<int> _key;
  final List<int> _s;

  RC4(List<int> key)
      : _key = List<int>.from(key),
        _s = List<int>.generate(256, (index) => index) {
    _initialize();
  }

  void _initialize() {
    int j = 0;
    for (int i = 0; i < 256; i++) {
      j = (j + _s[i] + _key[i % _key.length]) % 256;
      int temp = _s[i];
      _s[i] = _s[j];
      _s[j] = (temp + _key[i % _key.length]) % 256;
    }
  }

  List<int> _process(List<int> data) {
    List<int> result = List<int>.from(data);
    int i = 0;
    int j = 0;
    for (int k = 0; k < data.length; k++) {
      i = (i + 1) % 256;
      j = (j + _s[i]) % 256;
      int temp = _s[i];
      _s[i] = _s[j];
      _s[j] = temp;
      result[k] ^= _s[(_s[i] + _s[j]) % 256];
    }
    return result;
  }

  List<int> encrypt(List<int> data) {
    return _process(data);
  }

  List<int> decrypt(List<int> data) {
    return _process(data);
  }
}
