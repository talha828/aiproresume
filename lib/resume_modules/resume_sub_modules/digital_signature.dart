import 'dart:io';
import 'dart:ui' as ui;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../apis/webapi.dart';
import '../../common/colors.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../../common/app_utils.dart';

class DigitalSignature extends StatefulWidget {
  const DigitalSignature({super.key});

  @override
  State<DigitalSignature> createState() => _DigitalSignatureState();
}

class _DigitalSignatureState extends State<DigitalSignature>
    with SingleTickerProviderStateMixin {
  String? fileName;
  late TabController _tabController;
  String fontStyle = 'Freehand';
  GlobalKey globalKey = GlobalKey();
  GlobalKey keyText = GlobalKey();
  // _DigitalSignatureState() {
  //   _getCert();
  // }
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    // loadSigns();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  int? is_draw = 1, is_upload = 0, is_text = 0;
  String? filePath;
  void _pickFile() async {
    filePath = await FilePicker.platform
        .pickFiles(
          type: FileType.any,
        )
        .then((result) => result?.files.single.path);

    if (filePath != null) {
      print("File Path: " + filePath.toString());
      setState(() {
        fileName = filePath!.split('/').last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 10),
                  const CustomText(
                    text: "Signature",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Add or Update your signature.',
                  textColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              //body

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (value) {
                      print(value);
                      if (value == 0) {
                        is_draw = 1;
                        is_upload = 0;
                        is_text = 0;
                      } else if (value == 1) {
                        is_upload = 1;
                        is_draw = 0;
                        is_text = 0;
                      } else if (value == 2) {
                        is_text = 1;
                        is_upload = 0;
                        is_draw = 0;
                      }
                      print("draw: " + is_draw.toString());
                      print("Upload: " + is_upload.toString());
                      print("Text: " + is_text.toString());
                    },
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: Mycolors().blue,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      SizedBox(
                        width: double.infinity,
                        child: Tab(
                          text: 'Draw',
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Tab(
                          text: 'Upload',
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Tab(
                          text: 'TextField',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    // Draw
                    RepaintBoundary(
                      key: globalKey,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.black, strokeAlign: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 7,
                              offset: const Offset(
                                  4, 8), // changes position of shadow
                            ),
                          ],
                        ),
                        child: SfSignaturePad(
                          minimumStrokeWidth: 3,
                          maximumStrokeWidth: 3,
                          strokeColor: Mycolors().blue,
                          backgroundColor: Colors.grey[100],
                        ),
                      ),
                    ),

                    // image upload
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child:
                                CustomText(text: fileName ?? 'Attach Document'),
                          ),
                          IconButton(
                              onPressed: () {
                                _pickFile();
                              },
                              icon: const Icon(Icons.attach_file_outlined))
                        ],
                      ),
                    ),

                    //signature text
                    Column(
                      children: [
                        RepaintBoundary(
                          key: keyText,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: TextField(
                              cursorColor: Colors.black,
                              style:
                                  GoogleFonts.getFont(fontStyle, fontSize: 40),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorStyle: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 1.2,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _fontStyleChanger();
                          },
                          child: Container(
                            color: Colors.grey.shade300,
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: const EdgeInsets.all(12),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_drop_down_rounded),
                                CustomText(text: "Signature Style"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Center(
              //   child: FutureBuilder(
              //       future: _getCert(),
              //       builder: (BuildContext context, AsyncSnapshot snapshot) {
              //         if (snapshot.hasData) {
              //           return Image.network(
              //               height: 200,
              //               width: 200,
              //               fit: BoxFit.fill,
              //               'http://resume.cognitiveitsolutions.ca/public/images/${signList["0"]["image"].toString()}',
              //               errorBuilder: (context, error, stackTrace) {
              //             return const Text(
              //               "Failed to Load",
              //             );
              //           });
              //         } else {
              //           return const CircularProgressIndicator();
              //         }
              //       }),
              // ),

              const Spacer(),

              //buttom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    if (is_draw == 1 && is_upload == 0 && is_text == 0) {
                      _capturePng(globalKey);
                    } else if (is_upload == 1 && is_draw == 0 && is_text == 0) {
                      upload(filePath.toString());
                    } else if (is_text == 1 && is_upload == 0 && is_draw == 0) {
                      _capturePng(keyText);
                    }
                  },
                  buttonText: 'Add/Update',
                  sizeWidth: double.infinity,
                  sizeHeight: 55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fontStyleChanger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStatesb) {
            return AlertDialog(
              title: const Text('Select a font'),
              content: SingleChildScrollView(
                child: DropdownButton<String>(
                  value: fontStyle,
                  onChanged: (String? font) {
                    setState(() {
                      fontStyle = font!;
                    });
                    setStatesb(
                      () {
                        fontStyle = font!;
                      },
                    );
                  },
                  items: <String>[
                    'Freehand',
                    'Dancing Script',
                    'Zeyada',
                    'Kaushan Script',
                    'Mr Dafoe',
                    'Parisienne',
                    'Homemade Apple',
                    'Pinyon Script',
                    'Mrs Saint Delafield',
                    'La Belle Aurore',
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  ui.Image? image;
  Uint8List? pngBytes;
  ByteData? byteData;
  Future<void> _capturePng(key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    image = await boundary.toImage();
    print(image);
    byteData = await image!.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData!.buffer.asUint8List();

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';
    File customFile = await File(path).writeAsBytes(pngBytes!);

    Future.delayed(Duration(seconds: 1), () {
      // code to be executed after 2 seconds
      upload(customFile.path);
    });
  }

  upload(String path) async {
    CustomProgressDialogue.progressDialogue(context);

    File imageFile = File(path);
    // var stream = http.ByteStream(imageFile.openRead());
    // var stream=http.ByteStream(DelegatingStream.typed(file.openRead()));
    // stream.cast();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var profile_id = prefs.getString("profile_id");
    var length = imageFile.length;
    print("lengthimage:  " + length.toString());

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    Map<String, String> infoData = {
      'is_draw': is_draw.toString(),
      'is_upload': is_upload.toString(),
      "is_text": is_text.toString(),
      "profile_id": profile_id.toString(),
    };

    var fileExtension = AppUtils.getFileExtension(imageFile.toString());
    if (fileExtension.isEmpty) {
      print("Not found");
      return false;
    }

    var url = Uri.parse(
        "http://resume.cognitiveitsolutions.ca/public/api/user_digital_signature");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields.addAll(infoData);

    final file = await http.MultipartFile.fromPath('image', path,
        contentType: MediaType('application', "png"));

    request.files.add(file);

    http.Response response =
        await http.Response.fromStream(await request.send());

    print("Response: " + response.body);
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print("Data uploaded");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Updated Successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      print("Error: " + response.statusCode.toString());

      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error Updating...",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }

  CallApi _api = CallApi();

  dynamic signList = [];

  _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var pid = prefs.getString("profile_id");
    await _api.fetchSigns('user_digital_signature?profile_id=$pid', token);
    signList = _api.response;
    return signList;
  }
}
