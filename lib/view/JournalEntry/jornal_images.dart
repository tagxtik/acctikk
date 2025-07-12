import 'package:acctik/model/image_model.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:acctik/view/Widgets/image_preview.dart';
import 'package:acctik/view/Widgets/org_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class JornalImages extends StatefulWidget {
  const JornalImages({super.key, required this.jid, required this.orgid});
  final String orgid;
  final int jid;

  @override
  State<JornalImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<JornalImages> {
  final JornalService js = JornalService();
  List<ImageModel> _imageUrls = [];
  bool _isLoading = true;
  bool _isUploading = false;
  bool _isDeleting = false;

  Future<void> fetchImages() async {
    if (mounted) {
      setState(() {
        _isLoading = true;  // Start showing the loader when fetching starts
      });
    }

    List<ImageModel> images = await js.getimages(widget.jid,widget.orgid);
    if (mounted) {
      setState(() {
        _imageUrls = images;
        _isLoading = false;  // Stop showing the loader when fetching is done
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.add_a_photo),
          tooltip: 'Add Images',
          onPressed: () async {
            setState(() {
              _isUploading = true;  // Show loader during the upload process
            });

            final pickedImages = await ImagePicker().pickMultiImage();

            await js.uploadimg(widget.jid, pickedImages,widget.orgid);
            await fetchImages();  // Refresh the image list after upload
          
            if (mounted) {
              setState(() {
                _isUploading = false;  // Hide loader when upload is complete
              });
            }
          },
        ),

        if (_isUploading) 
          CircularProgressIndicator(),  // Show loader during image upload

        const SizedBox(
          height: 25,
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())  // Show loader when fetching images
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 250,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return _imageUrls.isEmpty
                              ? const Text("No Images")
                              : InkWell(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OrgCard(
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.transparent,
                                          child: Image.network(
                                              _imageUrls[index].imageUrl),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isDeleting = true;  // Show loader during delete
                                          });

                                          await js.deleteImage(
                                              widget.jid, _imageUrls[index].imageid ,widget.orgid);
                                          await fetchImages();  // Refresh image list after deletion

                                          if (mounted) {
                                            setState(() {
                                              _isDeleting = false;  // Hide loader when delete is complete
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                      if (_isDeleting) 
                                        CircularProgressIndicator(),  // Show loader while deleting
                                    ],
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ImagePreview(
                                            image: _imageUrls[index].imageUrl);
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
                        itemCount: _imageUrls.length,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
