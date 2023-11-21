import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_eep/firebase_options.dart';
import 'package:test_eep/youtube.dart';

void main() {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EEP test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const YouTubePlayerWithSeek(),
    );
  }
}

class Employee {
  final int id;
  String name;
  String language;
  String permission;

  Employee({
    required this.id,
    required this.name,
    required this.language,
    required this.permission,
  });
}

class DocumentModel {
  final String? name;
  final String? language;
  final String? permission;
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

Future<List<DocumentModel>> fetchDocuments() async {
  final snapshot = await FirebaseFirestore.instance.collection('users').get();

  final documents = snapshot.docs.map((doc) {
    final data = doc.data();
    return DocumentModel.fromMap(data);
  }).toList();

  return documents;
}

class EmployeeDataSource extends DataGridSource {
  List<Employee> employees;

  EmployeeDataSource(this.employees);
  EditingGestureType editingGestureType = EditingGestureType.doubleTap;

  @override
  List<DataGridRow> get rows => employees
      .map((employee) => DataGridRow(cells: [
            DataGridCell<int>(columnName: 'id', value: employee.id),
            DataGridCell<String>(columnName: 'name', value: employee.name),
            DataGridCell<String>(
                columnName: 'language', value: employee.language),
            DataGridCell<String>(
                columnName: 'permission', value: employee.permission),
          ]))
      .toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'name') {
          return Container(
            child: TextField(
              controller: TextEditingController(text: dataGridCell.value),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8.0),
              ),
            ),
          );
        } else if (dataGridCell.columnName == 'language') {
          return Container(
            child: DropdownButton<String>(
              value: dataGridCell.value,
              onChanged: (newValue) {
                final employeeId = row.getCells().first.value;
                final employee = employees
                    .firstWhere((employee) => employee.id == employeeId);
                employee.language = newValue!;
                notifyListeners();
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'EN',
                  child: Text('EN'),
                ),
                DropdownMenuItem<String>(
                  value: 'ES',
                  child: Text('ES'),
                ),
                DropdownMenuItem<String>(
                  value: 'DE',
                  child: Text('DE'),
                ),
              ],
            ),
          );
        } else if (dataGridCell.columnName == 'permission') {
          return Container(
            child: DropdownButton<String>(
              value: dataGridCell.value,
              onChanged: (newValue) {
                final employeeId = row.getCells().first.value;
                final employee = employees
                    .firstWhere((employee) => employee.id == employeeId);
                employee.permission = newValue!;
                notifyListeners();
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'Admin',
                  child: Text('Admin'),
                ),
                DropdownMenuItem<String>(
                  value: 'User',
                  child: Text('User'),
                ),
                DropdownMenuItem<String>(
                  value: 'Guest',
                  child: Text('Guest'),
                ),
              ],
            ),
          );
        } else {
          return Text(dataGridCell.value.toString());
        }
      }).toList(),
    );
  }
}

/// The home page of the application which hosts the datagrid.
class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List<Employee> employees = <Employee>[];
  // late EmployeeDataSource employeeDataSource;
  //  EditingGestureType editingGestureType = EditingGestureType.doubleTap;

  @override
  void initState() {
    super.initState();
    // employees = getEmployeeData();
    // employeeDataSource = EmployeeDataSource(employeeData: employees);
  }

  EditingGestureType editingGestureType = EditingGestureType.doubleTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('EEP Test'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SfDataGrid(
            allowEditing: true,

            columnWidthMode: ColumnWidthMode.fill,
            navigationMode: GridNavigationMode.cell,
            selectionMode: SelectionMode.single,
            editingGestureType: editingGestureType,

            // navigationMode: NavigationMode.directional,

            source: EmployeeDataSource([
              Employee(
                  id: 1,
                  language: 'EN',
                  name: 'Jane Smith',
                  permission: 'Admin'),
              Employee(
                  id: 2,
                  language: 'EN',
                  name: 'Jane Smith',
                  permission: 'Admin'),
              Employee(
                  id: 3,
                  language: 'EN',
                  name: 'Jane Smith',
                  permission: 'Admin'),
            ]),
            columns: [
              GridColumn(
                columnName: 'id',
                label: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: const Text(
                      'ID',
                    )),
              ),
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
                      child: const Text('Language'))),
              GridColumn(
                  columnName: 'permission',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Permission'))),
            ],
          ),
        )
        // SfDataGrid(
        //   allowEditing: true,
        //   source: employeeDataSource,
        //   columnWidthMode: ColumnWidthMode.fill,
        //   navigationMode: GridNavigationMode.cell,
        //   selectionMode: SelectionMode.single,
        // editingGestureType: editingGestureType,

        //   columns: <GridColumn>[
        //     GridColumn(
        //         columnName: 'id',
        //         label: Container(
        //             padding: const EdgeInsets.all(16.0),
        //             alignment: Alignment.center,
        //             child: const Text(
        //               'ID',
        //             ))),
        //     GridColumn(
        //         columnName: 'name',
        //         label: Container(
        //             padding: const EdgeInsets.all(8.0),
        //             alignment: Alignment.center,
        //             child: const Text('Name'))),
        //     GridColumn(
        //         columnName: 'designation',
        //         label: Container(
        //             padding: const EdgeInsets.all(8.0),
        //             alignment: Alignment.center,
        //             child: const Text(
        //               'Designation',
        //               overflow: TextOverflow.ellipsis,
        //             ))),
        //     GridColumn(
        //         columnName: 'salary',
        //         label: Container(
        //             padding: const EdgeInsets.all(8.0),
        //             alignment: Alignment.center,
        //             child: const Text('Salary'))),
        //   ],
        // ),
        );
  }

  List<Employers> getEmployeeData() {
    return [
      Employers(10001, 'James', 'Project Lead', 20000),
      Employers(10002, 'Kathryn', 'Manager', 30000),
      Employers(10003, 'Lara', 'Developer', 15000),
      Employers(10004, 'Michael', 'Designer', 15000),
      Employers(10005, 'Martin', 'Developer', 15000),
      Employers(10006, 'Newberry', 'Developer', 15000),
      Employers(10007, 'Balnc', 'Developer', 15000),
      Employers(10008, 'Perry', 'Developer', 15000),
      Employers(10009, 'Gable', 'Developer', 15000),
      Employers(10010, 'Grimes', 'Developer', 15000)
    ];
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employers {
  /// Creates the employee class with required details.
  Employers(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}
/*
/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
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
*/