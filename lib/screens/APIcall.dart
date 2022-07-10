import 'package:http/http.dart' as http;
import 'dart:io';

Future<void>uploadaudio(String filePath,String fileName)async {
  File audio = File(filePath);

    // var stream = http.ByteStream(audio!.openRead());
    // stream.cast();
    // var length = await audio!.length();
    var uri = Uri.parse('http://10.145.200.199/fft');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', audio.path));

    // var multiport = http.MultipartFile(
    //     'file',
    //     stream,9i
    //     length);
    // request.files.add(multiport);
    var response = await request.send();
    print(response.stream.toString());
    print(
        "ugcucveuoewcbewjbcuoewewbvuewovwv rhruhrureugubuvurfr buohfhruofh rufrufufouugf uu ru4");

}
