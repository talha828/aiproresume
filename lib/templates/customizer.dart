// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:aiproresume/apis/auth.dart';
import 'package:aiproresume/templates/pdfs/template_five_pdf.dart';
import 'package:aiproresume/templates/pdfs/template_four_pdf.dart';
import 'package:aiproresume/templates/pdfs/template_one_pdf.dart';
import 'package:aiproresume/templates/pdfs/template_three_pdf.dart';
import 'package:aiproresume/templates/pdfs/template_two_pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:aiproresume/global.dart' as global;
import '../../common/custom_text.dart';
import '../common/colors.dart';
import '../common/custom_elevatedbutton.dart';
import 'sub_customization_files/template_layoutfive.dart';
import 'sub_customization_files/template_layoutfour.dart';
import 'sub_customization_files/template_layoutone.dart';
import 'sub_customization_files/template_layoutthree.dart';
import 'sub_customization_files/template_layouttwo.dart';

class Customizer extends StatefulWidget {
  var data;

  Customizer({super.key, this.data});

  @override
  State<Customizer> createState() => _CustomizerState();
}

class _CustomizerState extends State<Customizer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late var templateIndex = int.parse('${widget.data}');
  late int selectedIndex = templateIndex;

  String baseUrl = Auth.baseUrl;
  String alltemplateendpoist = Auth.alltemplateEndpoint;

  pdfPreviews() {
    if (selectedIndex == 1) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const TemplateOnePdf(),
          //  const TemplateTwo(),
        ),
      );
    } else if (selectedIndex == 2) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const TemplateTwopdf(),
        ),
      );
    } else if (selectedIndex == 3) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const TemplateThreePdf(),
        ),
      );
    } else if (selectedIndex == 4) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const TemplateFourPdf(),
        ),
      );
    } else if (selectedIndex == 5) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => TemplateFivePdf(),
        ),
      );
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.preview),
                label: "Preview",
                backgroundColor: Mycolors().blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: "Customize",
                backgroundColor: Mycolors().blue,
              ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            // selectedItemColor: Colors.yellow,
            iconSize: 20,
            onTap: (value) {
              if (value == 0) {
                pdfPreviews();
              } else if (value == 1) {
                _bottomSheet(context);
              }
            },
            elevation: 5),
        body: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              //header
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 10),
                  const CustomText(
                    text: "Customizer",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => super.widget));
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),

              //body
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        if (selectedIndex != -1) ...[
                          Container(
                            height:
                                MediaQuery.of(context).size.height, // * 0.50,
                            width: MediaQuery.of(context).size.width, // * 0.80,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 8.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(0.0, 0.0),
                                )
                              ],
                            ),
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              return _buildLayoutForIndex(selectedIndex);
                            }),
                          ),
                        ],
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//layout to edit
  Widget _buildLayoutForIndex(int index) {
    switch (index) {
      case 1:
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return const LayoutOne();
          },
        );
      case 2:
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return const LayoutTwo();
          },
        );
      case 3:
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return const LayoutThree();
          },
        );
      case 4:
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return const LayoutFour();
          },
        );
      case 5:
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return const LayoutFive();
          },
        );
      // Add cases for other layouts
      default:
        return Container(); // Placeholder container if no layout matches the index
    }
  }

  void _bottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Background one and two color
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _backgroundOneColorPicker();
                          },
                          icon: Icons.colorize_outlined,
                          label: 'Background One Color',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _backgroundTwoColorPicker();
                          },
                          icon: Icons.colorize_outlined,
                          label: 'Background Two Color',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  //Text color
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _font1ColorChanger();
                          },
                          icon: Icons.colorize_outlined,
                          label: 'Text one Color',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _font2ColorChanger();
                          },
                          icon: Icons.colorize_outlined,
                          label: 'Text two Color',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  //heading color
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _headung1ColorChanger();
                          },
                          icon: Icons.colorize_outlined,
                          label: 'Heading one Color',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _headung2ColorChanger();
                          },
                          icon: Icons.colorize_outlined,
                          label: 'Heading two Color',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  //text and heading size
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _fontSizeChanger();
                          },
                          icon: Icons.text_increase_outlined,
                          label: 'Text Size',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _headingSizeChanger();
                          },
                          icon: Icons.text_fields,
                          label: 'Heading Size',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  //icon color and font style
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _fontStyleChanger();
                          },
                          icon: Icons.font_download_outlined,
                          label: 'Font Style',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _iconColorPicker();
                          },
                          icon: Icons.color_lens_outlined,
                          label: 'Icon Color',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  //profile shap & template color
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _imageshapchanger();
                          },
                          icon: Icons.shape_line_outlined,
                          label: 'Profile shape change',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButtonIcon(
                          onPressed: () {
                            _templateColorPicker();
                          },
                          icon: Icons.color_lens_outlined,
                          label: 'Template Color',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  //add section
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButtonIcon(
                          icon: Icons.add,
                          onPressed: () {
                            _addremoveSheet(context);
                          },
                          label: 'Add/Remove Section',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addremoveSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (
        BuildContext context,
      ) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: ListView(
              children: [
                //Profile Imgage
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Image", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showImage,
                        onChanged: (value) {
                          setState(() {
                            global.showImage = value;
                          });
                          setStateSB(
                            () {
                              global.showImage = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Summary
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Summary", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showsummary,
                        onChanged: (value) {
                          setState(() {
                            global.showsummary = value;
                          });
                          setStateSB(
                            () {
                              global.showsummary = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Qulification
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Qualification", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showEducation,
                        onChanged: (value) {
                          setState(() {
                            global.showEducation = value;
                          });
                          setStateSB(
                            () {
                              global.showEducation = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Experience
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Experience", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showExperience,
                        onChanged: (value) {
                          setState(() {
                            global.showExperience = value;
                          });
                          setStateSB(
                            () {
                              global.showExperience = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //TechSkill
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Skills", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showSkill,
                        onChanged: (value) {
                          setState(() {
                            global.showSkill = value;
                          });
                          setStateSB(
                            () {
                              global.showSkill = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                // Softskill switch
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Soft Skills", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showSoftSkill,
                        onChanged: (value) {
                          setState(() {
                            global.showSoftSkill = value;
                          });
                          setStateSB(
                            () {
                              global.showSoftSkill = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Languages switch
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Languages", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showLanguages,
                        onChanged: (value) {
                          setState(() {
                            global.showLanguages = value;
                          });
                          setStateSB(
                            () {
                              global.showLanguages = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Certificate switch
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Certificate", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showCertificates,
                        onChanged: (value) {
                          setState(() {
                            global.showCertificates = value;
                          });
                          setStateSB(
                            () {
                              global.showCertificates = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Awards
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Award", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showAwards,
                        onChanged: (value) {
                          setState(() {
                            global.showAwards = value;
                          });
                          setStateSB(
                            () {
                              global.showAwards = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Hobbies
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Hobbie", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showHobbies,
                        onChanged: (value) {
                          setState(() {
                            global.showHobbies = value;
                          });
                          setStateSB(
                            () {
                              global.showHobbies = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Reference
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Reference", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showReference,
                        onChanged: (value) {
                          setState(() {
                            global.showReference = value;
                          });
                          setStateSB(
                            () {
                              global.showReference = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Signature
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Signature", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showSignature,
                        onChanged: (value) {
                          setState(() {
                            global.showSignature = value;
                          });
                          setStateSB(
                            () {
                              global.showSignature = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),

                //Extra Details
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const CustomText(text: "Extra Details", fontSize: 16),
                  trailing: StatefulBuilder(
                    builder: (BuildContext context, setStateSB) {
                      return Switch(
                        activeColor: Mycolors().blue,
                        value: global.showExtarDetail,
                        onChanged: (value) {
                          setState(() {
                            global.showExtarDetail = value;
                          });
                          setStateSB(
                            () {
                              global.showExtarDetail = value;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[400]),
              ],
            ),
          ),
        );
      },
    );
  }

  //template color changer
  void _templateColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: global.bg1color = global.bg2color ?? Colors.white,
              onColorChanged: (Color color) {
                setState(() {
                  global.bg1color = color;
                  global.bg2color = color;
                });
              },
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
  }

  //background color
  void _backgroundOneColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: global.bg1color ?? Colors.white,
              onColorChanged: (Color color) {
                setState(() {
                  global.bg1color = color;
                });
              },
              pickerAreaHeightPercent: 0.6,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //background color
  void _backgroundTwoColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: global.bg2color ?? Colors.white,
              onColorChanged: (Color color) {
                setState(() {
                  global.bg2color = color;
                });
              },
              pickerAreaHeightPercent: 0.6,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // icon color
  void _iconColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: global.iconColor ?? Colors.black,
              onColorChanged: (Color color) {
                setState(() {
                  global.iconColor = color;
                });
              },
              pickerAreaHeightPercent: 0.6,
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
  }

  //image shap
  void _imageshapchanger() {
    Picker(
      adapter: PickerDataAdapter<String>(pickerData: [
        'Circle',
        'Square',
      ]),
      hideHeader: true,
      selecteds: [global.imageShape.index],
      title: const Text('Select Image Shape'),
      onConfirm: (Picker picker, List<int> value) {
        setState(() {
          global.imageShape = global.ImageShape.values[value[0]];
        });
      },
    ).showDialog(context);
  }

  //font size changer
  void _fontSizeChanger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStatesb) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: DropdownButton<double>(
                  value: global.fontSize,
                  items: global.fontSizes.map((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (double? value) {
                    setState(() {
                      global.fontSize = value!;
                    });

                    setStatesb(
                      () {
                        global.fontSize = value!;
                      },
                    );
                  },
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

  //heading size changer
  void _headingSizeChanger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStatesb) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: DropdownButton<double>(
                  value: global.headingSize,
                  items: global.headingFontSizes.map((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (double? value) {
                    setState(() {
                      global.headingSize = value!;
                    });

                    setStatesb(
                      () {
                        global.headingSize = value!;
                      },
                    );
                  },
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

  //font style
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
                  value: global.fontStyle,
                  onChanged: (String? font) {
                    setState(() {
                      global.fontStyle = font!;
                    });
                    setStatesb(
                      () {
                        global.fontStyle = font!;
                      },
                    );
                  },
                  items: <String>[
                    'Poppins',
                    'Roboto',
                    'Open Sans',
                    'Lato',
                    'Montserrat',
                    'Raleway',
                    'Freehand',
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

  //font one color changer
  void _font1ColorChanger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: global.font1color ?? Colors.black,
              onColorChanged: (Color color) {
                setState(() {
                  global.font1color = color;
                });
              },
              pickerAreaHeightPercent: 0.6,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //fnont two color changer
  void _font2ColorChanger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: global.font2color ?? Colors.black,
              onColorChanged: (Color color) {
                setState(() {
                  global.font2color = color;
                });
              },
              pickerAreaHeightPercent: 0.6,
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
  }

  // heading one color changer
  void _headung1ColorChanger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: global.heading1color ?? Colors.black,
              onColorChanged: (Color color) {
                setState(() {
                  global.heading1color = color;
                });
              },
              pickerAreaHeightPercent: 0.6,
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
  }

  //heading two color changer
  void _headung2ColorChanger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: global.heading2color ?? Colors.black,
              onColorChanged: (Color color) {
                setState(() {
                  global.heading2color = color;
                });
              },
              pickerAreaHeightPercent: 0.6,
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
  }
}
