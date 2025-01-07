import 'package:flutter/material.dart';


class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Container(
       height: double.infinity,
       width: double.infinity,
       decoration: const BoxDecoration(
         gradient: LinearGradient(
           colors: [
                  Color.fromARGB(255, 43, 162, 253),
                  Color.fromARGB(255, 177, 77, 253),
           ]
         )
       ),
       child: Column(
         children: [
           const Padding(
             padding: EdgeInsets.only(top: 200.0),
             // child: Image(image: AssetImage('assets/logo.png')),
           ),
           const SizedBox(height: 100),
           const Text('NETTORY', style: TextStyle(fontSize: 30, color: Colors.white)),
           const SizedBox(height: 30),
           
           
           GestureDetector(
             onTap: () {
               Navigator.pushNamed(context, '/login');
             },
             child: Container(
               height: 53,
               width: 320,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(30),
                 border: Border.all(color: Colors.white),
               ),
               child: const Center(
                 child: Text('LOG IN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
               ),
             ),
           ),
           const SizedBox(height: 30),
           
           
           
           GestureDetector(
             onTap: () {
               Navigator.pushNamed(context, '/register');
             },
             child: Container(
               height: 53,
               width: 320,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(30),
                 border: Border.all(color: Colors.white),
               ),
               child: const Center(
                 child: Text('REGISTER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
               ),
             ),
           ),
           //const Spacer(),
           // const Text('Login with Social Media', style: TextStyle(fontSize: 17, color: Colors.white)),
           //const SizedBox(height: 12),
           //const Image(image: AssetImage('assets/social.png'))
         ]
       ),
     ),
    );
  }
}
