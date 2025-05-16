// Standard character-to-braille mapping
const Map<String, String> _brailleMap = {
  // Letters
  'a': '⠁', 'b': '⠃', 'c': '⠉', 'd': '⠙',
  'e': '⠑', 'f': '⠋', 'g': '⠛', 'h': '⠓',
  'i': '⠊', 'j': '⠚', 'k': '⠅', 'l': '⠇',
  'm': '⠍', 'n': '⠝', 'o': '⠕', 'p': '⠏',
  'q': '⠟', 'r': '⠗', 's': '⠎', 't': '⠞',
  'u': '⠥', 'v': '⠧', 'w': '⠺', 'x': '⠭',
  'y': '⠽', 'z': '⠵',

  // Digits
  '1': '⠁', '2': '⠃', '3': '⠉', '4': '⠙',
  '5': '⠑', '6': '⠋', '7': '⠛', '8': '⠓',
  '9': '⠊', '0': '⠚',

  // Punctuation / math
  ',': '⠂', ';': '⠆', ':': '⠒', '.': '⠲',
  '!': '⠖', '?': '⠦', '-': '⠤', ' ': ' ',
  '/': '⠌',
  '\'': '⠄',
  '\\': '⠡',
  '"': '⠄⠶',
  '“': '⠘⠦',
  '”': '⠘⠴',
  '‘': '⠄⠦',
  '’': '⠄⠴',
  '(': '⠐⠣',
  ')': '⠐⠜',
  // MATH
  '+': '⠖',
  '=': '⠒⠒',
  '*': '⠡',
  '%': '⠨⠴',
  '^': '⠘',
  '<': '⠣',
  '>': '⠜',
  '≠': '⠒',
  // Unicode math symbols
  '≤': '⠲⠣',
  '≥': '⠲⠜',
};

// Multi-character symbols (e.g., <=, =>)
const Map<String, String> _brailleMultiCharMap = {
  '<=': '⠲⠣',
  '>=': '⠲⠜',
  '=>': '⠰⠶',
};

const String _capitalIndicator = '⠠';
const String _numberIndicator = '⠼';

String latinToBraille(String text) {
  final buffer = StringBuffer();
  bool numberMode = false;

  for (int i = 0; i < text.length; i++) {
    // Check for two-character symbol pairs
    if (i + 1 < text.length) {
      final pair = text.substring(i, i + 2);
      if (_brailleMultiCharMap.containsKey(pair)) {
        buffer.write(_brailleMultiCharMap[pair]);
        i++;
        numberMode = false;
        continue;
      }
    }

    var char = text[i];

    // Handle capital letters
    if (RegExp(r'[A-Z]').hasMatch(char)) {
      buffer.write(_capitalIndicator);
      char = char.toLowerCase();
    }

    // Handle digits
    if (RegExp(r'\d').hasMatch(char)) {
      if (!numberMode) {
        buffer.write(_numberIndicator);
        numberMode = true;
      }
      buffer.write(_brailleMap[char]);
    } else {
      numberMode = false;
      buffer.write(_brailleMap[char] ?? '');
    }
  }

  return buffer.toString();
}
