import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
   final String image;

  const ImagePreview({super.key, required this.image});
  @override
  Widget build(BuildContext context) {
    print(image);
    return AlertDialog(
      title: const Text("Image Preview"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
               child: Hero(
                tag: 'Acctik',
                child: Image.network(
                  image,
                ),
              ),
            ),
            
        
          ],
        ),
      ),
      actions: [
         
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
           
          child: const Text('OK'),
        ),
      ],
    );
  }
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//      AlertDialog(
//        title: Text("title"),
//       content: Scaffold(
//         body: GestureDetector(
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Hero(
//               tag: 'imageHero',
//               child: Image.network(
//                 image,
//               ),
//             ),
//           ),
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//     );
//   }
// }