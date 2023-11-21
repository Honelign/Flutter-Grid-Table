import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// The home page of the application which hosts the datagrid.
class OnlyRead extends StatefulWidget {
  /// Creates the home page.
  const OnlyRead({Key? key}) : super(key: key);

  @override
  _OnlyReadState createState() => _OnlyReadState();
}

class DocumentModel {
  String? name;
  String? language;
  String? permission;
  final int? id;

  DocumentModel({this.name, this.language, this.permission, this.id});

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      name: map['name'],
      language: map['language'],
      permission: map['permission'],
      id: map['id'],
    );
  }
}

class _OnlyReadState extends State<OnlyRead> {
  // List<Employee> employees = <Employee>[];

  late EmployeeDataSource employeeDataSource;

  List<DocumentModel> usersFetched = [];
  Future<List<DocumentModel>> fetchDocuments() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final documents = snapshot.docs.map((doc) {
      final data = doc.data();
      return DocumentModel.fromMap(data);
    }).toList();
    debugPrint(documents.map((e) => e.id).toString());
    usersFetched = documents;

    employeeDataSource = EmployeeDataSource(employeeData: documents);
    return documents;
  }

  @override
  void initState() {
    super.initState();
    fetchDocuments();

    employeeDataSource = EmployeeDataSource(employeeData: usersFetched);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error occured'));
            }

            return SfDataGrid(
              // columnWidthMode = ColumnWidthMode.fill,
              // source = employeeDataSource,
              source: employeeDataSource,
              columnWidthMode: ColumnWidthMode.fill,
              columns: <GridColumn>[
                GridColumn(
                    columnName: 'id',
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'ID',
                        ))),
                GridColumn(
                    columnName: 'name',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Name'))),
                GridColumn(
                    columnName: 'language',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Language',
                          overflow: TextOverflow.ellipsis,
                        ))),
                GridColumn(
                    columnName: 'permission',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Permission'))),
              ],
            );
          }),
    );
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<DocumentModel> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'language', value: e.language),
              DataGridCell<String>(
                  columnName: 'permission', value: e.permission),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
