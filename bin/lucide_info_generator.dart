import 'dart:convert';
import 'dart:io';

void main() async {
  final inputDir = Directory('input');
  final output = File('output/output.json');

  if (output.existsSync()) {
    output.deleteSync();
  }

  output.writeAsStringSync('[ ');

  await inputDir.list().forEach((element) async {
    if (element is File) {
      await _readContentsAndWriteToFile(element, output);
    }
  });

  // content
  //   ..removeLast()
  //   ..forEach(writer.writeln);

  output.writeAsStringSync(']', mode: FileMode.writeOnlyAppend);
}

Future<void> _readContentsAndWriteToFile(
  File content,
  File output,
) async {
  final unformattedLines = await utf8.decoder
      .bind(content.openRead())
      .transform(const LineSplitter())
      .toList();

  final formatedLines = <String>[];
  final name = content.path.split(Platform.pathSeparator)[1].split('.')[0];

  for (var i = 0; i < unformattedLines.length; i++) {
    formatedLines.add(unformattedLines[i]);
    if (i == 1) {
      formatedLines.add('"name":"$name",');
    }
    if (i == unformattedLines.length - 1) {
      formatedLines.add(',');
    }
  }

  formatedLines.forEach((element) {
    output.writeAsStringSync('$element\n', mode: FileMode.writeOnlyAppend);
  });

  return;
}
