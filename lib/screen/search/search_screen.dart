import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final startController=TextEditingController();
  final endController=TextEditingController();

  late GooglePlace googlePlace;

  List<AutocompletePrediction> predictions=[];
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String apiKeys='AIzaSyCEZcfkFhjlmixGG7APA1EBFfAkSzjSPb8';
    googlePlace =GooglePlace(apiKeys);
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      print(result.predictions!.length);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                decoration:const InputDecoration(
                    filled: true,
                    hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                    hintText: 'Starting Point',
                    fillColor:Color.fromARGB(255, 213, 209, 209),
                    border:InputBorder.none,
                ),
                onChanged: (value){
                    if(value.isNotEmpty){
                      //return api place result
                      autoCompleteSearch(value);
                    }else{
                      //clear the result
                    }},
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: endController,
                style: TextStyle(fontSize: 20),
                decoration:InputDecoration(
                  filled: true,
                  hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                  hintText: 'End Point',
                  fillColor:const Color.fromARGB(255, 213, 209, 209),
                  border:InputBorder.none,
                ),
                onChanged: (value){
                  if(timer?.isActive ?? false) timer!.cancel();
                  timer=Timer(const Duration(milliseconds: 300), (){
                    if(value.isNotEmpty){
                      //return api place result
                      autoCompleteSearch(value);
                    }else{
                      //clear the result
                    }
                  });
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length,
                  itemBuilder: (context,index){
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.pin_drop,color: Colors.white,),
                    ),
                    title: Text(predictions[index].description.toString()),
                  );
              })
            ],
          ),
        ),
      )
    );
  }
}
