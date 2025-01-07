import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  _AddAssetPageState createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _macAddressController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _switchController = TextEditingController();
  final TextEditingController _portNumberController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _updateByController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final CollectionReference _assetCollection =
      FirebaseFirestore.instance.collection('assets');

  // Instance of Firebase Analytics
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> _addAsset() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _assetCollection.add({
          'id': _idController.text,
          'name': _nameController.text,
          'serialNumber': _serialNumberController.text,
          'macAddress': _macAddressController.text,
          'model': _modelController.text,
          'switch': _switchController.text,
          'portNumber': _portNumberController.text,
          'supplier': _supplierController.text,
          'updateDate': Timestamp.now(), // Automatically sets to current date
          'updateBy': _updateByController.text,
          'note': _noteController.text,
        });

        // Log the event to Firebase Analytics
        await _analytics.logEvent(
          name: 'add_asset',
          parameters: {
            'asset_id': _idController.text,
            'asset_name': _nameController.text,
            'serial_number': _serialNumberController.text,
            'mac_address': _macAddressController.text,
            'model': _modelController.text,
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset added successfully')),
        );

        // Clear the form after adding the asset
        _formKey.currentState!.reset();
        _idController.clear();
        _nameController.clear();
        _serialNumberController.clear();
        _macAddressController.clear();
        _modelController.clear();
        _switchController.clear();
        _portNumberController.clear();
        _supplierController.clear();
        _updateByController.clear();
        _noteController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add asset: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Asset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: 'Asset ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an asset ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Asset Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an asset name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _serialNumberController,
                  decoration: const InputDecoration(labelText: 'Serial Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the serial number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _macAddressController,
                  decoration: const InputDecoration(labelText: 'MAC Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the MAC address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(labelText: 'Model'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the model';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _switchController,
                  decoration: const InputDecoration(labelText: 'Switch'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the switch';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _portNumberController,
                  decoration: const InputDecoration(labelText: 'Port Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the port number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _supplierController,
                  decoration: const InputDecoration(labelText: 'Supplier'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the supplier';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _updateByController,
                  decoration: const InputDecoration(labelText: 'Updated By'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the staff name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(labelText: 'Note'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a note';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _addAsset,
                  child: const Text('Add Asset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
