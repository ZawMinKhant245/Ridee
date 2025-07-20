import 'package:firstapp1/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor:Color.fromARGB(255, 245, 232, 232),
      pages: [
        PageViewModel(
            titleWidget: Text(''),
          bodyWidget: buildIntroScreen(
              context,
              1,
              'Enjoy with Us, and discover the joy of a hassle  free ride',
            'sit back ,relax and enjoy the ride. Your satisfaction in our priority',
            'assets/img.png',
            ''
          )
        ),
        PageViewModel(
            titleWidget: Text(''),
          bodyWidget: buildIntroScreen(
              context,
              2,
              '',
            'Simple ride-hailing for your daily commute or urgent trips.',
            'assets/car.png',
            'Your everyday ride partner—just tap and go.'
          )
        ),
        PageViewModel(
            titleWidget: Text(''),
          bodyWidget: buildIntroScreen(
              context,
              3,
              'We prioritize your safety with real-time tracking and responsible drivers.',
            '',
            '',
            'Ride with confidence—your safety is always our top priority.'
          )
        ),
      ],
      onDone: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
      },
      onSkip: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
      },
      showSkipButton: true,
      skipOrBackFlex: 1,
      nextFlex: 1,
      dotsFlex: 2,

      skip: Text(
        'Skip',
        style: TextStyle(color: Colors.black),
      ),
      next: Icon(Icons.arrow_forward,color: Colors.black,),
      done: Text(
        'Getting Started',
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
      ),
      dotsDecorator: DotsDecorator(
        color: Colors.black,
        size: Size(5, 5),
        activeSize: Size(8, 8),
        activeColor: Colors.black,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        )
      ),
    );
  }

  Widget buildIntroScreen(BuildContext context,int pageId,String? title,String? bodyText,String image,String? footerText){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title!,style: pageId==1 ? TextStyle(fontWeight: FontWeight.bold,fontSize: 33): TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
        const SizedBox(height: 20,),
        Text(bodyText!,style: pageId !=2 && pageId !=3 ? TextStyle(fontWeight: FontWeight.w500,color: Color.fromARGB(
            255, 136, 127, 127)):
        TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
        const SizedBox(height: 20,),
        pageId!=3?Image.asset(image,width: 250,):Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
              children: [
                Expanded(child: Image.asset('assets/male.png',)),
                Expanded(child: Image.asset('assets/img_1.png'))
              ],
          ),
        ),
        const SizedBox(height: 40,),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text(footerText!,style: TextStyle(color: Color.fromARGB(255, 27, 26, 26)),textAlign: TextAlign.center,),
        )
      ],
    );
  }
}
