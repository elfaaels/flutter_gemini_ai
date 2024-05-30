import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myapp/global_variables.dart';
import 'package:image_picker/image_picker.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController textEditingController = TextEditingController();
  String answer = '';
  XFile? image;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: const Text(
          'Gemini AI Demo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Type anything here...',
                    labelText: 'Ask me Anything!',
                  ),
                  onSaved: (String? value) {},
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
              ),
               const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                      color: image == null ? Colors.grey.shade200 : null,
                      image: image != null
                          ? DecorationImage(image: FileImage(File(image!.path)))
                          : null),
                ),
                const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                    ImagePicker().pickImage(source: ImageSource.gallery).then(
                      (value) {
                        setState(() {
                          image = value;
                        });
                      },
                    );
                },
                child: const Text(
                  'Pick Image',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  GenerativeModel model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
                  // model.generateContent([
                  //   Content.text(textEditingController.text)
                  //   ]).then((value) {
                  //     setState(() {
                  //       answer = value.text.toString();
                  //     });
                  // });
                  model.generateContent([
                    Content.multi(
                      [
                        TextPart(textEditingController.text),
                        if(image != null)
                        DataPart('image/jpeg', File(image!.path).readAsBytesSync())
                      ]
                    )
                  ]).then((value) {
                    setState(() {
                      answer = value.text.toString();
                    });
                  });
                },
                child: const Text(
                  'Send',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text('Here you go...',                 
                style: TextStyle(fontSize: 18, color: Colors.black), ),
              Container(
                child: Text(answer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
