
import 'package:acctik/view/Widgets/image_preview.dart';
import 'package:acctik/view/Widgets/org_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImages extends StatefulWidget {
  
  const UploadImages({super.key, required this.selectedImages});
  final List<XFile> selectedImages;
  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
 void removeItem(int index) {
  setState(() {
    widget.selectedImages.removeAt(index);
  });
}
  @override
  Widget build(BuildContext context) {
    return   Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 150,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: Column(
                    children: [
                      OrgCard(
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.transparent,
                          child: Image.network(widget.selectedImages[index].path),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                         removeItem(index);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  onTap: () {
                    print(widget.selectedImages[index].path);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ImagePreview(image: widget.selectedImages[index].path);
                      },
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  indent: 5,
                );
              },
              itemCount: widget.selectedImages.length,
            ),
          ),
        ),
      ),
    );
  }
}


