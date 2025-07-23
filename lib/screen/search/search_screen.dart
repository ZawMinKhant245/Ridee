
import 'dart:async';

import 'package:firstapp1/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({required this.currentLocation,super.key});
  final currentLocation;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final startController=TextEditingController();
  final endController=TextEditingController();

 late GooglePlace googlePlace;
 List<AutocompletePrediction>predictions=[];


 DetailsResult? startPosition; //to get lat and long
 DetailsResult? endPosition;

 late FocusNode startFocusMode; //to focus the textField
 late  FocusNode endFocusMode;

 Timer? time;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String apiKeys="AIzaSyBAhBRF5SO0Ov2nbcfyhmFzfsXUr44D2Nw";
    googlePlace=GooglePlace(apiKeys);
    startFocusMode = FocusNode();
    endFocusMode = FocusNode();

    if(startController.text.isEmpty){
      startController.text=widget.currentLocation!.toString();
    }
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    startFocusMode.dispose();
    endFocusMode.dispose();
  }




  Future<void> autoCompleteSearch(String value) async {
   final result=await googlePlace.autocomplete.get(value);
   if(result != null && result.predictions != null && mounted){
     print(result.predictions!.first.description);
     setState(() {
       predictions=result.predictions!;
     });

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
                      predictions=[];
                      startController.clear();
                    });
                  }, icon: Icon(Icons.clear)): null
                ),
                onChanged: (value) async {
                  if(time?.isActive?? false) time!.cancel();
                  time=Timer(const Duration(milliseconds: 1000), (){
                    if(value.isNotEmpty){
                      //call api
                      autoCompleteSearch(value);
                    }else{
                      //clear the reslt
                      setState(() {
                        predictions=[];
                        startPosition=null;
                      });
                    }
                  });

                }
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: endController,
                focusNode: endFocusMode,
                style: TextStyle(fontSize: 20),
                enabled: startController.text.isNotEmpty && startPosition !=null,
                decoration:InputDecoration(
                  filled: true,
                  hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                  hintText: 'End Point',
                  fillColor:const Color.fromARGB(255, 213, 209, 209),
                  border:InputBorder.none,
                    suffixIcon: endController.text.isNotEmpty? IconButton(onPressed: (){
                      setState(() {
                        predictions=[];
                        endController.clear();
                      });
                    }, icon: Icon(Icons.clear)): null
                ),
                  onChanged: (value) async {
                    if(time?.isActive?? false) time!.cancel();
                    time=Timer(const Duration(milliseconds: 1000), (){
                      if(value.isNotEmpty){
                        //call api
                        autoCompleteSearch(value);
                      }else{
                        //clear the reslt
                        setState(() {
                          predictions=[];
                          startPosition=null;
                        });
                      }
                    });

                  }
              ),
              Container(
                height: 600,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:predictions.length ,
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
                        title: Text(predictions[index].description.toString()),
                        onTap: () async {
                         final placeId= predictions[index].placeId;
                         final details=await googlePlace.details.get(placeId!);
                         if(details != null && details.result  != null && mounted){
                           if(startFocusMode.hasFocus){
                             setState(() {
                               startPosition=details.result;
                               startController.text=details.result!.name!;
                               predictions=[];
                             });
                           }else{
                             setState(() {
                               endPosition=details.result;
                               endController.text=details.result!.name!;
                               predictions=[];
                             });
                           }
                           if(startPosition != null && endPosition != null){
                             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen(startPosition: startPosition,endPosition: endPosition,)));
                           }

                         }
                        },
                      ),
                    );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
