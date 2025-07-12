enum LogData {
  addorg,
  editorg,
  addmain,
  editmain,
  addsub,
  editsub,
  addjor,
  editjor,
  addimg,
  editimg;

  @override
  String toString() {
    switch (this) {
      case LogData.addorg:
        return 'Add';
      case LogData.editorg:
        return 'Option 2';
      case LogData.addmain:
        return 'Option 3';
         case LogData.editmain:
        return 'Add';
      case LogData.addsub:
        return 'Option 2';
      case LogData.editsub:
        return 'Option 3';
         case LogData.addjor:
        return 'Add';
      case LogData.editjor:
        return 'Option 2';
      case LogData.addimg:
        return 'Option 3';
         case LogData.editimg:
        return 'Add';
 
    }
  }
}