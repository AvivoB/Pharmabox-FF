import 'dart:convert';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;

class GoogleSheetsApi {
  final String spreadsheetId = '1Hu0ww4yrl7M9UaUJyPuzCpSqTIP1_wDktGsBVt04y9A';
  final String sheetName = 'Laboratoires';

//   Future<List> fetchData() async {
//     // final url = 'https://docs.google.com/spreadsheets/d/$spreadsheetId/export?format=xlsx';

//     // final response = await http.get(Uri.parse(url));

//     // if (response.statusCode == 200) {
//     //   final bytes = response.bodyBytes;
//     //   return _parseExcel(bytes);
//     // } else {
//     //   throw Exception('Erreur de chargement des données: ${response.statusCode}');
//     // }
    
//   }
// }

// List _parseExcel(Uint8List bytes) {
//   var excel = Excel.decodeBytes(bytes);
//   List data = [];


//     for (var table in excel.tables.keys) {
//       var sheet = excel.tables[table];

//       if (sheet != null) {
//         // Lire la première ligne comme entêtes
//         List<String> headers = sheet.rows.isNotEmpty ? sheet.rows[0].map((cell) => cell?.value.toString() ?? '').toList() : [];


//         // Lire les lignes suivantes et créer un Map pour chaque ligne
//         for (var i = 1; i < sheet.rows.length; i++) {
//           var row = sheet.rows[i];
//           Map<String, String> rowData = {};

//           for (var j = 0; j < headers.length; j++) {
//             // Assurer que l'index de la cellule n'excède pas la longueur de l'en-tête
//             if (j < row.length) {
//               rowData[headers[j]] = row[j]?.value.toString() ?? '';
//             }
//           }

//           data.add(rowData);
//         }
//       }
//     }

//   return data;
}
