import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nettory_app/pages/addasset.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Asset extends StatefulWidget {
  const Asset({super.key});

  @override
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<Asset> {
  final CollectionReference _assetCollection =
      FirebaseFirestore.instance.collection('assets');
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance; // Instance of Firebase Analytics
  String _searchKeyword = "";

  Future<void> _deleteAsset(String assetId) async {
    try {
      await _assetCollection.doc(assetId).delete();

      // Log the event to Firebase Analytics
      await _analytics.logEvent(
        name: 'delete_asset',
        parameters: {'asset_id': assetId},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asset deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete asset: $e')),
      );
    }
  }

  void _showUpdateDialog(String assetId, Map<String, dynamic> data) {
    final TextEditingController idController = TextEditingController(text: data['id']);
    final TextEditingController nameController = TextEditingController(text: data['name']);
    final TextEditingController serialNumberController =
        TextEditingController(text: data['serialNumber']);
    final TextEditingController macAddressController =
        TextEditingController(text: data['macAddress']);
    final TextEditingController modelController = TextEditingController(text: data['model']);
    final TextEditingController switchController = TextEditingController(text: data['switch']);
    final TextEditingController portNumberController =
        TextEditingController(text: data['portNumber']);
    final TextEditingController supplierController =
        TextEditingController(text: data['supplier']);
    final TextEditingController updatedByController =
        TextEditingController(text: data['updatedBy']);
    final TextEditingController noteController = TextEditingController(text: data['note']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Asset'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: idController, decoration: const InputDecoration(labelText: 'ID')),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: serialNumberController, decoration: const InputDecoration(labelText: 'Serial Number')),
                TextField(controller: macAddressController, decoration: const InputDecoration(labelText: 'MAC Address')),
                TextField(controller: modelController, decoration: const InputDecoration(labelText: 'Model')),
                TextField(controller: switchController, decoration: const InputDecoration(labelText: 'Switch')),
                TextField(controller: portNumberController, decoration: const InputDecoration(labelText: 'Port Number')),
                TextField(controller: supplierController, decoration: const InputDecoration(labelText: 'Supplier')),
                TextField(controller: updatedByController, decoration: const InputDecoration(labelText: 'Updated By')),
                TextField(controller: noteController, decoration: const InputDecoration(labelText: 'Note')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                try {
                  await _assetCollection.doc(assetId).update({
                    'id': idController.text,
                    'name': nameController.text,
                    'serialNumber': serialNumberController.text,
                    'macAddress': macAddressController.text,
                    'model': modelController.text,
                    'switch': switchController.text,
                    'portNumber': portNumberController.text,
                    'supplier': supplierController.text,
                    'updatedBy': updatedByController.text,
                    'note': noteController.text,
                    'updateDate': Timestamp.fromDate(DateTime.now()),
                  });

                  // Log the event to Firebase Analytics
                  await _analytics.logEvent(
                    name: 'update_asset',
                    parameters: {
                      'asset_id': assetId,
                      'asset_name': nameController.text,
                    },
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Asset updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update asset: $e')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Management'),
        backgroundColor: const Color.fromARGB(255, 43, 162, 253),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search by Name or Serial Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) async {
                setState(() {
                  _searchKeyword = value.toLowerCase();
                });
                // Log search event
                await _analytics.logEvent(
                  name: 'search_asset',
                  parameters: {'search_keyword': value},
                );
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 43, 162, 253),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAssetPage()),
                    );
                    // Log navigation event
                    await _analytics.logEvent(name: 'navigate_add_asset');
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Add Asset', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _assetCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No assets found'));
                  }

                  final assets = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return (data['name'] ?? '').toLowerCase().contains(_searchKeyword) ||
                        (data['serialNumber'] ?? '').toLowerCase().contains(_searchKeyword);
                  }).toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Serial Number')),
                        DataColumn(label: Text('MAC Address')),
                        DataColumn(label: Text('Model')),
                        DataColumn(label: Text('Switch')),
                        DataColumn(label: Text('Port Number')),
                        DataColumn(label: Text('Supplier')),
                        DataColumn(label: Text('Update Date')),
                        DataColumn(label: Text('Updated By')),
                        DataColumn(label: Text('Note')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: assets.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DataRow(
                          cells: [
                            DataCell(Text(data['id'] ?? 'N/A')),
                            DataCell(Text(data['name'] ?? 'N/A')),
                            DataCell(Text(data['serialNumber'] ?? 'N/A')),
                            DataCell(Text(data['macAddress'] ?? 'N/A')),
                            DataCell(Text(data['model'] ?? 'N/A')),
                            DataCell(Text(data['switch'] ?? 'N/A')),
                            DataCell(Text(data['portNumber'] ?? 'N/A')),
                            DataCell(Text(data['supplier'] ?? 'N/A')),
                            DataCell(Text(data['updateDate'] != null
                                ? (data['updateDate'] as Timestamp).toDate().toString()
                                : 'N/A')),
                            DataCell(Text(data['updatedBy'] ?? 'N/A')),
                            DataCell(Text(data['note'] ?? 'N/A')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _showUpdateDialog(doc.id, data),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteAsset(doc.id),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
