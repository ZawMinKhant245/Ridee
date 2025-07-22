
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final startController=TextEditingController();
  final endController=TextEditingController();
  List<String> suggestions = [];

 late FocusNode startFocusMode;
 late  FocusNode endFocusMode;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startFocusMode = FocusNode();
    endFocusMode = FocusNode();
  }

  Future<List<String>> searchPlace(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5');

    final response = await http.get(url, headers: {
      'User-Agent': 'Ridee (mzaw17591@gmail.com)' // Nominatim policy
    });

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((place) => place['display_name'] as String).toList();
    } else {
      throw Exception('Failed to load place suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your route'),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: startController,
                style: TextStyle(fontSize: 20),
                focusNode: startFocusMode,
                decoration:InputDecoration(
                    filled: true,
                    hintStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                    hintText: 'Starting Point',
                    fillColor:const Color.fromARGB(255, 213, 209, 209),
                    border:InputBorder.none,
                  suffixIcon: startController.text.isNotEmpty? IconButton(onPressed: (){
                    setState(() {
                      startController.clear();
                      suggestions.clear();
                    });
                  }, icon: Icon(Icons.clear)): null
                ),
                onChanged: (value) async {
                  if (value.length > 1) {
                    final results = await searchPlace(value);
                    setState(() {
                      suggestions = results;
                    });
                  }
                }
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: endController,
                focusNode: endFocusMode,
                style: TextStyle(fontSize: 20),
                decoration:InputDecoration(
                  filled: true,
                  hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                  hintText: 'End Point',
                  fillColor:const Color.fromARGB(255, 213, 209, 209),
                  border:InputBorder.none,
                    suffixIcon: endController.text.isNotEmpty? IconButton(onPressed: (){
                      setState(() {
                        endController.clear();
                        suggestions.clear();
                      });
                    }, icon: Icon(Icons.clear)): null
                ),
                onChanged: (value) async {
                  if (value.length > 2) {
                    final results = await searchPlace(value);
                    setState(() {
                      suggestions = results;
                    });
                  }
                },
              ),
              Container(
                height: 600,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:suggestions.length ,
                    itemBuilder: (context,index){
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:BorderSide(color: Colors.grey,width: 0.5)
                        )
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          child: Icon(Icons.pin_drop,color: Colors.white,),
                        ),
                        title: Text(suggestions[index]),
                        shape: RoundedRectangleBorder(),
                        onTap: (){
                            if(startFocusMode.hasFocus){
                              setState(() {
                                startController.text=suggestions[index];
                                suggestions=[];
                              });
                            }else if(endFocusMode.hasFocus){
                              setState(() {
                                endController.text=suggestions[index];
                                suggestions=[];
                              });
                            }

                        },
                      ),
                    );
                }),
              )
            ],
          ),
        ),
      )
    );
  }
}
