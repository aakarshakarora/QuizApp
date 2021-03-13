import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;

/// Represents the XlsIO stateful widget class.
class CreateExcel extends StatefulWidget {


  @override
  _CreateExcelState createState() => _CreateExcelState();
}

class _CreateExcelState extends State<CreateExcel> {
  int count = 2;
   String accessCode;
  final accessCodeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Excel"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                labelText: 'Enter Access Code:',
                labelStyle: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Poppins',
                )),
            keyboardType: TextInputType.text,
            controller: accessCodeController,
          ),
          FlatButton(
            child: const Text(
              'Download Responses',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () async {

              setState(() {
                accessCode=accessCodeController.text+'Result';
              });
              generateExcel(accessCode);
            },
          ),
        ],
      ),
    );
  }

  Future<void> generateExcel(String accessCode) async {
    print("Function Called");
    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    //Set data in the worksheet.

    sheet.getRangeByName('A1').setText('Name');
    sheet.getRangeByName('B1').setText('ID');
    sheet.getRangeByName('C1').setText('Email ID');
    sheet.getRangeByName('D1').setText('Score');
    sheet.getRangeByName('E1').setText('Tab Switch');
    sheet.getRangeByName('F1').setText('Logged In');
    sheet.getRangeByName('G1').setText('User ID');
    sheet.getRangeByName('H1').setText('Max Score');
    String subjectName;
    String code;
    code=accessCode.substring(0,5);

    final cloud = await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(code)
        .collection(accessCode)
        .get();


    print("Code is: $accessCode");



    for(var document in cloud.docs){




      sheet.getRangeByName('A'+count.toString()).setText(document.data()['S_Name'].toString());
      sheet.getRangeByName('B'+count.toString()).setText(document.data()['S_RegNo'].toString());
      sheet.getRangeByName('C'+count.toString()).setText(document.data()['S_EmailID'].toString());
      sheet.getRangeByName('D'+count.toString()).setText(document.data()['Score'].toString());
      sheet.getRangeByName('E'+count.toString()).setText(document.data()['tabSwitch'].toString());
      sheet.getRangeByName('F'+count.toString()).setText(document.data()['attempted'].toString());
      sheet.getRangeByName('G'+count.toString()).setText(document.data()['S_UID'].toString());
      sheet.getRangeByName('H'+count.toString()).setText(document.data()['maxScore'].toString());

      count++;
    }



      await FirebaseFirestore.instance.collection('Quiz').doc(code).get().then((value) {
        subjectName=value.data()['SubjectName'];
      });


    // await for (var snapshot in cloud) {
    //   for (var document in snapshot.docs) {
    //     setState(() {
    //       count++;
    //     });
    //     print("Output A1:" + document.data()['Ques']);
    //     print("Output B1:" + document.data()['01']);
    //     print("Output C1:" + document.data()['02']);
    //     sheet.getRangeByName('A1').setText(document.data()['Ques']);
    //     sheet.getRangeByName('B1').setText(document.data()['01']);
    //     sheet.getRangeByName('C1').setText(document.data()['02']);
    //   }
    // }
    // for(int i=1;i<=10;i++){
    //   sheet.getRangeByName('A'+i.toString()).setText(i.toString());
    //   sheet.getRangeByName('B'+i.toString()).setText((i+1).toString());
    //   sheet.getRangeByName('C'+i.toString()).setText((i+2).toString());
    // }

    sheet.getRangeByName('A1:E1').cellStyle.backColor = '#FFFF00';
    sheet.getRangeByName('A1:E1').cellStyle.bold = true;
    //sheet.getRangeByName('A1:H1').merge();

    // sheet.getRangeByName('B4').setText('Invoice');
    // sheet.getRangeByName('B4').cellStyle.fontSize = 32;
    //
    // sheet.getRangeByName('B8').setText('BILL TO:');
    // sheet.getRangeByName('B8').cellStyle.fontSize = 9;
    // sheet.getRangeByName('B8').cellStyle.bold = true;
    //
    // sheet.getRangeByName('B9').setText('Abraham Swearegin');
    // sheet.getRangeByName('B9').cellStyle.fontSize = 12;
    //
    // sheet
    //     .getRangeByName('B10')
    //     .setText('United States, California, San Mateo,');
    // sheet.getRangeByName('B10').cellStyle.fontSize = 9;
    //
    // sheet.getRangeByName('B11').setText('9920 BridgePointe Parkway,');
    // sheet.getRangeByName('B11').cellStyle.fontSize = 9;
    //
    // sheet.getRangeByName('B12').setNumber(9365550136);
    // sheet.getRangeByName('B12').cellStyle.fontSize = 9;
    // sheet.getRangeByName('B12').cellStyle.hAlign = HAlignType.left;

    // final Range range1 = sheet.getRangeByName('F8:G8');
    // final Range range2 = sheet.getRangeByName('F9:G9');
    // final Range range3 = sheet.getRangeByName('F10:G10');
    // final Range range4 = sheet.getRangeByName('F11:G11');
    // final Range range5 = sheet.getRangeByName('F12:G12');

    // range1.merge();
    // range2.merge();
    // range3.merge();
    // range4.merge();
    // range5.merge();
    //
    // sheet.getRangeByName('F8').setText('INVOICE#');
    // range1.cellStyle.fontSize = 8;
    // range1.cellStyle.bold = true;
    // range1.cellStyle.hAlign = HAlignType.right;
    //
    // sheet.getRangeByName('F9').setNumber(2058557939);
    // range2.cellStyle.fontSize = 9;
    // range2.cellStyle.hAlign = HAlignType.right;
    //
    // sheet.getRangeByName('F10').setText('DATE');
    // range3.cellStyle.fontSize = 8;
    // range3.cellStyle.bold = true;
    // range3.cellStyle.hAlign = HAlignType.right;
    //
    // sheet.getRangeByName('F11').dateTime = DateTime(2020, 08, 31);
    // sheet.getRangeByName('F11').numberFormat =
    //     '[\$-x-sysdate]dddd, mmmm dd, yyyy';
    // range4.cellStyle.fontSize = 9;
    // range4.cellStyle.hAlign = HAlignType.right;
    //
    // range5.cellStyle.fontSize = 8;
    // range5.cellStyle.bold = true;
    // range5.cellStyle.hAlign = HAlignType.right;
    //
    // final Range range6 = sheet.getRangeByName('B15:G15');
    // range6.cellStyle.fontSize = 10;
    // range6.cellStyle.bold = true;
    //
    // sheet.getRangeByIndex(15, 2).setText('Code');
    // sheet.getRangeByIndex(16, 2).setText('CA-1098');
    // sheet.getRangeByIndex(17, 2).setText('LJ-0192');
    // sheet.getRangeByIndex(18, 2).setText('So-B909-M');
    // sheet.getRangeByIndex(19, 2).setText('FK-5136');
    // sheet.getRangeByIndex(20, 2).setText('HL-U509');
    //
    // sheet.getRangeByIndex(15, 3).setText('Description');
    // sheet.getRangeByIndex(16, 3).setText('AWC Logo Cap');
    // sheet.getRangeByIndex(17, 3).setText('Long-Sleeve Logo Jersey, M');
    // sheet.getRangeByIndex(18, 3).setText('Mountain Bike Socks, M');
    // sheet.getRangeByIndex(19, 3).setText('ML Fork');
    // sheet.getRangeByIndex(20, 3).setText('Sports-100 Helmet, Black');
    //
    // sheet.getRangeByIndex(15, 3, 15, 4).merge();
    // sheet.getRangeByIndex(16, 3, 16, 4).merge();
    // sheet.getRangeByIndex(17, 3, 17, 4).merge();
    // sheet.getRangeByIndex(18, 3, 18, 4).merge();
    // sheet.getRangeByIndex(19, 3, 19, 4).merge();
    // sheet.getRangeByIndex(20, 3, 20, 4).merge();
    //
    // sheet.getRangeByIndex(15, 5).setText('Quantity');
    // sheet.getRangeByIndex(16, 5).setNumber(2);
    // sheet.getRangeByIndex(17, 5).setNumber(3);
    // sheet.getRangeByIndex(18, 5).setNumber(2);
    // sheet.getRangeByIndex(19, 5).setNumber(6);
    // sheet.getRangeByIndex(20, 5).setNumber(1);
    //
    // sheet.getRangeByIndex(15, 6).setText('Price');
    // sheet.getRangeByIndex(16, 6).setNumber(8.99);
    // sheet.getRangeByIndex(17, 6).setNumber(49.99);
    // sheet.getRangeByIndex(18, 6).setNumber(9.50);
    // sheet.getRangeByIndex(19, 6).setNumber(175.49);
    // sheet.getRangeByIndex(20, 6).setNumber(34.99);
    //
    // sheet.getRangeByIndex(15, 7).setText('Total');
    // sheet.getRangeByIndex(16, 7).setFormula('=E16*F16+(E16*F16)');
    // sheet.getRangeByIndex(17, 7).setFormula('=E17*F17+(E17*F17)');
    // sheet.getRangeByIndex(18, 7).setFormula('=E18*F18+(E18*F18)');
    // sheet.getRangeByIndex(19, 7).setFormula('=E19*F19+(E19*F19)');
    // sheet.getRangeByIndex(20, 7).setFormula('=E20*F20+(E20*F20)');
    // sheet.getRangeByIndex(15, 6, 20, 7).numberFormat = '\$#,##0.00';
    //
    // sheet.getRangeByName('E15:G15').cellStyle.hAlign = HAlignType.right;
    // sheet.getRangeByName('B15:G15').cellStyle.fontSize = 10;
    // sheet.getRangeByName('B15:G15').cellStyle.bold = true;
    // sheet.getRangeByName('B16:G20').cellStyle.fontSize = 9;
    //
    // sheet.getRangeByName('E22:G22').merge();
    // sheet.getRangeByName('E22:G22').cellStyle.hAlign = HAlignType.right;
    // sheet.getRangeByName('E23:G24').merge();
    //
    // final Range range7 = sheet.getRangeByName('E22');
    // final Range range8 = sheet.getRangeByName('E23');
    // range7.setText('TOTAL');
    // range7.cellStyle.fontSize = 8;
    // range8.setFormula('=SUM(G16:G20)');
    // range8.numberFormat = '\$#,##0.00';
    // range8.cellStyle.fontSize = 24;
    // range8.cellStyle.hAlign = HAlignType.right;
    // range8.cellStyle.bold = true;

    // sheet.getRangeByIndex(26, 1).text =
    //     '800 Interchange Blvd, Suite 2501, Austin, TX 78721 | support@adventure-works.com';
    // sheet.getRangeByIndex(26, 1).cellStyle.fontSize = 8;
    //
    // final Range range9 = sheet.getRangeByName('A26:H27');
    // range9.cellStyle.backColor = '#ACB9CA';
    // range9.merge();
    // range9.cellStyle.hAlign = HAlignType.center;
    // range9.cellStyle.vAlign = VAlignType.center;

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Get the storage folder location using path_provider package.
    final Directory directory =
    await path_provider.getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/$subjectName $code.xlsx');
    await file.writeAsBytes(bytes);

    //Launch the file (used open_file package)

    await open_file.OpenFile.open('$path/$subjectName $code.xlsx');

    print("File Saved at:" + path);
    print("Code is: $accessCode");
    print("Result is: $code");
  }
}
