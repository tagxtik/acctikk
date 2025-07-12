import 'dart:typed_data'; // For Uint8List
import 'package:acctik/global/jDetailMod.dart';
import 'package:acctik/model/image_model.dart';
import 'package:acctik/model/jornal_model_details.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // To check if it's web
import 'dart:io' if (kIsWeb) 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class JornalService {
  //final CollectionReference jornal =
  //   FirebaseFirestore.instance.collection("journals");

  Future<void> addJournalWithSubcollection(
    String orgid,
    int jornalid,
    String jornalname,
    String jornaldesc,
    String entredBy,
    entredDate,
    double totaldeb,
    double totalcred,
    String mainid,
    String subid,
    String subname,
    double value,
    String type,
    List<XFile> images,
  ) async {
    print("Start Entring Data ,,,,, ");
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    int id = 0;

    getMaxJorID(orgid).then((onValue) async {
      print("maxid" + onValue.toString());
      id = await getMaxJorID(orgid);
      DocumentReference journalDocRef = firestore
          .collection('orgs')
          .doc(orgid)
          .collection("journals")
          .doc(jornalid.toString());

      // Step 1: Create a new journal document with an auto-generated ID
      await journalDocRef.set(
          {
            'orgid': orgid,
            'jornalid': jornalid,
            'jornalname': jornalname,
            'jornaldesc': jornaldesc,
            'entredby': entredBy,
            'entredDate': entredDate,
            'totaldeb': totaldeb,
            'totalcred': totalcred,
          },
          SetOptions(
              merge:
                  true)); // Use `merge: true` to avoid overwriting if it already exists
      print(" Step 1: Create a new journal document with an auto-generated ID");
      // Get the auto-generated document ID

      // Step 2: Add a document to the 'notes' subcollection of this journal
      CollectionReference jdetails = journalDocRef.collection('jdetails');

      // Adding a note to the subcollection
      await jdetails.add({
        'mainid': mainid,
        'subid': subid,
        'subname': subname,
        'jornalid': jornalid,
        'value': value,
        'type': type,
        'entredby': entredBy,
        'entredDate': entredDate,
      });
      print(" Step 2: Create a new jdetail");

      print(onValue + 1);
    });
    // Step 1: Define the main document ID (you can set this ID or generate it programmatically)
  }

  Future<int> getMaxJorID(String orgid) async {
    try {
      // Query the 'journals' collection ordered by 'jornalid' in descending order, limited to 1
      final querySnapshot = await FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgid)
          .collection("journals")
          .orderBy('jornalid', descending: true)
          .limit(1)
          .get();

      // Check if the collection contains any documents
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document
        final document = querySnapshot.docs.first;

        // Extract 'jornalid' and handle both String and int types
        final journalId = document.data()['jornalid'];

        if (journalId is int) {
          print("From inside function, Returned ID (int): $journalId");
          return journalId; // If it's already an int, return it
        } else if (journalId is String) {
          // Try converting the string to an int
          final int? parsedId = int.tryParse(journalId);
          if (parsedId != null) {
            print(
                "From inside function, Returned ID (parsed from String): $parsedId");
            return parsedId;
          } else {
            print(
                "From inside function, Could not parse journalid from String");
            return 0; // Return 0 if the conversion fails
          }
        } else {
          return 0; // Return 0 if the type is neither int nor String
        }
      } else {
        return 0; // Return 0 if the collection is empty
      }
    } catch (e) {
      print('Error fetching maximum journal ID: $e');
      return 0; // Return 0 if there is an error
    }
  }

  Stream<QuerySnapshot> getJornals(String orgid) {
    return FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgid)
        .collection("journals")
        .snapshots();
  }

  Stream<QuerySnapshot> getJornalsByid(String orgid, int jid) {
    return FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgid)
        .collection("journals")
        .where('jornalid', isEqualTo: jid)

        // End date
        .snapshots();
  }

  Stream<QuerySnapshot> getJornalsByDate(
      String orgid, DateTime startDate, DateTime endDate) {
    return FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgid)
        .collection("journals")
        .where('entredDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate)) // Start date
        .where('entredDate',
            isLessThanOrEqualTo: Timestamp.fromDate(endDate)) // End date
        .snapshots();
  }

  Future<void> updateMainData(
      String orgid, int jid, String jname, DateTime date, String jdesc) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      // Step 1: Update the parent document (journal)
      DocumentReference journalRef = FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgid)
          .collection("journals")
          .doc(jid.toString()); // Parent journal document reference

      batch.update(journalRef, {
        'jornalname': jname,
        'jornaldesc': jdesc,
        'entredDate': Timestamp.fromDate(date),
      });

      print("Parent journal document updated.");

      // Step 2: Retrieve the subcollection documents
      QuerySnapshot subcollectionSnapshot = await FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgid)
          .collection("journals")
          .doc(jid.toString())
          .collection('jdetails')
          .get();

      if (subcollectionSnapshot.docs.isEmpty) {
        print("No documents found in subcollection.");
      } else {
        // Step 3: Update each subcollection document's date field
        for (DocumentSnapshot subDoc in subcollectionSnapshot.docs) {
          String docId = subDoc.id;
          print("Updating document in subcollection with ID: $docId");

          DocumentReference subJournalRef = subDoc.reference;
          batch.update(subJournalRef, {'entredDate': Timestamp.fromDate(date)});
        }
      }

      // Step 4: Commit the batch to apply all updates atomically
      await batch.commit();
      print("Successfully updated the parent document and subcollection.");
    } catch (e) {
      print("Error updating documents: $e");
    }
  }

  Future<void> deleteJournalWithSubcollections(int docId, String orgid) async {
    // Reference to the document you want to delete
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgid)
        .collection("journals")
        .doc(docId.toString());

    // Fetch all documents in the subcollections manually (if known)
    await _deleteSubcollectionsManually(docRef, 'images');
    await _deleteSubcollectionsManually(docRef, 'jdetails');

    // Delete the document itself
    await docRef.delete();
    print('Document and its subcollections deleted successfully.');
  }

  Future<void> _deleteSubcollectionsManually(
      DocumentReference docRef, String subcollectionName) async {
    final subcollection = docRef.collection(subcollectionName);

    // Get all documents in the subcollection
    QuerySnapshot subcollectionSnapshot = await subcollection.get();

    for (QueryDocumentSnapshot doc in subcollectionSnapshot.docs) {
      // Delete the document
      await doc.reference.delete();
    }

    print('Subcollection $subcollectionName deleted.');
  }

  Future<List<ImageModel>> getimages(int journalId, String orgid) async {
    List<ImageModel> imageUrls = [];
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query Firestore to get images where 'id' matches journalId
      QuerySnapshot querySnapshot = await _firestore
          .collection('orgs')
          .doc(orgid)
          .collection("journals")
          .doc(journalId.toString())
          .collection("images")
          .get();

      for (var doc in querySnapshot.docs) {
        String imageUrl = doc['imageUrl'];

        final newimage = ImageModel(
            imageUrl: imageUrl, imageid: doc.id, jornalid: journalId);
        imageUrls.add(newimage);
      }
    } catch (e) {
      print("Error retrieving images: $e");
    }

    return imageUrls;
  }

  Future<void> deleteImage(int journalId, String imageId, String orgid) async {
    try {
      final imageRef = FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgid)
          .collection("journals")
          .doc(journalId.toString())
          .collection('images')
          .doc(imageId);

      await imageRef.delete();

      print('Image deleted successfully!');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> uploadimg(int jornalid, List<XFile> images, String orgid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final storageRef = FirebaseStorage.instance.ref();
    DocumentReference journalDocRef = firestore
        .collection('orgs')
        .doc(orgid)
        .collection("journals")
        .doc(jornalid.toString());
    CollectionReference imagesSubcollection =
        journalDocRef.collection('images');

    for (var image in images) {
      String imageName = image.name; // Get the image file name from XFile
      final String uniqueFilePath =
          'journal_images/${jornalid}/${DateTime.now().millisecondsSinceEpoch}_$imageName';

      if (kIsWeb) {
        // Web: Use Uint8List to upload image data
        Uint8List? imageData =
            await image.readAsBytes(); // Convert XFile to bytes
        final uploadTask = await storageRef
            .child(uniqueFilePath)
            .putData(imageData); // Upload Uint8List
        final imageUrl = await uploadTask.ref.getDownloadURL();

        // Store image URL in the 'images' subcollection
        await imagesSubcollection.add({
          'id': jornalid,
          'imageUrl': imageUrl,
          'uploadedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Mobile: Use File (dart:io) to upload the image
        File imageFile = File(image.path); // Convert XFile to File
        final uploadTask = await storageRef
            .child(uniqueFilePath)
            .putFile(imageFile); // Upload File
        final imageUrl = await uploadTask.ref.getDownloadURL();
        print(" Step 3: Create a new Images");
        // Store image URL in the 'images' subcollection
        await imagesSubcollection.add({
          'imageUrl': imageUrl,
          'uploadedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  Future<void> fetchJournalEntries(int jid, String orgid) async {
    // Initialize Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String jids = jid.toString();

    // Fetch the sub-collection 'jdetails' under the 'journals' document with the given journal ID (jid)
    QuerySnapshot querySnapshot = await firestore
        .collection('orgs')
        .doc(orgid)
        .collection("journals") // Access the 'journals' collection
        .doc(jids) // Select the document with the given journal ID
        .collection("jdetails") // Access the 'jdetails' sub-collection
        .get();

    // Initialize your change notifier (Jdetailmod) to handle the entries
    Jdetailmod jmod = Jdetailmod();

    // Iterate over the documents in the 'jdetails' sub-collection
    for (var doc in querySnapshot.docs) {
      // Convert the 'entredDate' from Firestore's Timestamp to DateTime
      Timestamp jdate = doc["entredDate"];
      DateTime dateTime = jdate.toDate();

      // Convert 'jornalid' to an int, checking if it's stored as a String
      int journalId;
      if (doc["jornalid"] is String) {
        journalId =
            int.tryParse(doc["jornalid"]) ?? 0; // Default to 0 if parsing fails
      } else if (doc["jornalid"] is int) {
        journalId = doc["jornalid"];
      } else {
        journalId = 0; // Default if unexpected type
      }

      // Create a new JornalModelDetails object for each entry
      final data = doc.data()
          as Map<String, dynamic>?; // Cast to Map and handle nullable case

      final newItem = JornalModelDetails(
        jornalId: journalId, // Default to 0 if missing
        entredDate: dateTime,
        entredBy: data?["entredby"] ?? "Unknown",
        type: data?["type"] ?? "N/A",
        mainid: data?["mainid"] ?? "N/A",
        subid: data?["subid"] ?? "N/A",
        //   subname: data?["subname"] ??
        //      "N/A", // Default to "N/A" if "subname" is missing
        value: data?["value"]?.toDouble() ??
            0.0, // Ensures double type for "value"
      );

      // Add the new item to the list of journal entries
      await jmod.addJornalItem(newItem);
    }

    // Notify that journal entries were successfully fetched and processed
    print("Journal entries fetched and added successfully.");
  }

  Future<void> addImgs(List<XFile> images, String id, String entredBy,
      DateTime entredDate, String orgid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgid)
        .collection("journals");
    DocumentReference journalDocRef = firestore
        .collection('orgs')
        .doc(orgid)
        .collection("journals")
        .doc(id.toString());
    final storageRef = FirebaseStorage.instance.ref();
    CollectionReference imagesSubcollection =
        journalDocRef.collection('images');
    for (var image in images) {
      String imageName = image.name; // Get the image file name from XFile
      final String uniqueFilePath =
          'journal_images/${id}/${DateTime.now().millisecondsSinceEpoch}_$imageName';

      if (kIsWeb) {
        // Web: Use Uint8List to upload image data
        Uint8List? imageData =
            await image.readAsBytes(); // Convert XFile to bytes
        final uploadTask = await storageRef
            .child(uniqueFilePath)
            .putData(imageData); // Upload Uint8List
        final imageUrl = await uploadTask.ref.getDownloadURL();

        // Store image URL in the 'images' subcollection
        await imagesSubcollection.add(
          {
            'id': id,
            'imageUrl': imageUrl,
            'uploadedAt': entredDate,
            'entredby': entredBy
          },
        );
      } else {
        // Mobile: Use File (dart:io) to upload the image
        File imageFile = File(image.path); // Convert XFile to File
        final uploadTask = await storageRef
            .child(uniqueFilePath)
            .putFile(imageFile); // Upload File
        final imageUrl = await uploadTask.ref.getDownloadURL();
        print(" Step 3: Create a new Images");
        // Store image URL in the 'images' subcollection
        await imagesSubcollection.add({
          'id': id,
          'imageUrl': imageUrl,
          'uploadedAt': entredDate,
          'entredby': entredBy
        });
      }
    }
  }

  Future<void> updateJornal(int journalId, List<JornalModelDetails> items,
      double totaldeb, double totalcred, String orgid) async {
    Timestamp? jdate;
    DateTime? dateTime;
    String entredBy = "";
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference jdetails = firestore
        .collection('orgs')
        .doc(orgid)
        .collection("journals")
        .doc(journalId.toString())
        .collection('jdetails');

    // Step 1: Fetch the current data to get necessary values (only once)
    try {
      QuerySnapshot subcollectionSnapshot = await jdetails.get();
      for (var doc in subcollectionSnapshot.docs) {
        // Fetch necessary data from the existing documents
        jdate = doc["entredDate"];
        dateTime = jdate!.toDate();
        entredBy = doc["entredby"];
      }

      // Step 2: Delete existing documents in the 'jdetails' subcollection
      await deleteSubcollection(jdetails);

      // Step 3: Re-insert new data from 'items' list
      for (var item in items) {
        await jdetails.add({
          'mainid': item.mainid,
          'subid': item.subid,
          'value': item.value,
          'type': item.type,
          'entredby': entredBy,
          'entredDate': dateTime,
          'jornalid': journalId,
          //   'subname': item.subname,
        });

        print('Reinserted document: ${item.jornalId}');
      }
      DocumentReference journalRef = FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgid)
          .collection("journals")
          .doc(journalId.toString()); // Parent journal document reference
      await journalRef.update({'totaldeb': totaldeb, 'totalcred': totalcred});

      print("Parent journal document updated.");
    } catch (e) {
      print('Error updating Firebase with delete and reinsert: $e');
    }
  }

// Utility function to delete all documents in a subcollection
  Future<void> deleteSubcollection(CollectionReference subcollectionRef) async {
    var snapshot = await subcollectionRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Stream<QuerySnapshot> getFilteredResults(String orgId, String searchText) {
    return FirebaseFirestore.instance
        .collectionGroup('sub')
        .where('orgid', isEqualTo: orgId)
        .where('accountname', isGreaterThanOrEqualTo: searchText)
        .where('accountname',
            isLessThanOrEqualTo:
                searchText + '\uf8ff') // Unicode to capture partial matches
        .snapshots();
  }

  Future<String?> getMainAccountName(String orgId, String mainAccountId) async {
    try {
      print(
          "Fetching main account name for orgId: $orgId, mainAccountId: $mainAccountId");
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("orgs")
          .doc(orgId)
          .collection("main")
          .doc(mainAccountId)
          .get();

      if (snapshot.exists) {
        print("Document found: ${snapshot.data()}");
        return snapshot.get('accountname');
      } else {
        print("Document not found for mainAccountId: $mainAccountId");
        return null;
      }
    } catch (e) {
      print("Error fetching main account name: $e");
      return null;
    }
  }

  Future<String?> getSubname(
      String orgId, String mainAccountId, String subid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("orgs")
          .doc(orgId)
          .collection("main")
          .doc(mainAccountId)
          .collection("sub")
          .doc(subid)
          .get();

      if (snapshot.exists) {
        return snapshot.get('accountname'); // Assuming the name field is "name"
      } else {
        return null; // Return null if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching main account name: $e");
      return null; // Return null in case of an error
    }
  }

  Future<String?> getOrgname(String orgId) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("orgs").doc(orgId).get();

      if (snapshot.exists) {
        return snapshot.get('orgname'); // Assuming the name field is "name"
      } else {
        return null; // Return null if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching main account name: $e");
      return null; // Return null in case of an error
    }
  }

  Future<String?> getDesc(String orgId, int jids) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('orgs')
          .doc(orgId)
          .collection("journals")
          .doc(jids.toString())
          .get();

      if (snapshot.exists) {
        return snapshot.get('jornaldesc'); // Assuming the name field is "name"
      } else {
        return null; // Return null if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching main account name: $e");
      return null; // Return null in case of an error
    }
  }
}
