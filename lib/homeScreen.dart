import 'package:firstapp1/screen/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
          children:[
            Image.asset('assets/img_2.png',height: 200,fit: BoxFit.cover,),
            DraggableScrollableSheet(
                builder: (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 248, 240, 240),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                         const Icon(Icons.horizontal_rule,weight: 200,),
                          Text('Choose your desination',style: TextStyle(fontSize: 18),),
                          const SizedBox(height: 20,),
                          TextField(
                            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchScreen())),
                            autofocus: false,
                            showCursor: false,
                            decoration:InputDecoration(
                              filled: true,
                              hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                              hintText: 'Where To?',
                              prefixIcon: const Icon(Icons.search),
                              fillColor:const Color.fromARGB(255, 213, 209, 209),
                              border:InputBorder.none,
                              suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.map_sharp)),
                              suffixIconColor: Color.fromARGB(255, 207, 61, 30)
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            )
          ]
      ),
    );
  }

}