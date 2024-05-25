import 'dart:convert';
import 'dart:io';

void main() async {
  final inputDir = Directory('input');
  final output = File('output/output.json');

  if (output.existsSync()) {
    await output.delete();
  }

  final content = <String>[];

  await inputDir.list().forEach((element) async {
    if (element is File) {
      content.addAll(await _readContentsAndWriteToFile(element));
    }
  });

  final writer = output.openWrite(mode: FileMode.append)..writeln('[ ');

  content
    ..removeLast()
    ..forEach(writer.writeln);

  writer.writeln(']');

  await writer.close();
}

Future<List<String>> _readContentsAndWriteToFile(File content) async {
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

  return formatedLines;
}
