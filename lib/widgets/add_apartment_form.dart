import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddApartmentForm extends StatefulWidget {
  const AddApartmentForm({super.key});

  @override
  State<AddApartmentForm> createState() => _AddApartmentFormState();
}

class _AddApartmentFormState extends State<AddApartmentForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String location = '';
  String description = '';
  double price = 0.0;
  bool available = true;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _mediaFiles = [];
  List<String> _mediaTypes = [];

  // Pick image or video
  Future<void> _pickMedia({required bool isVideo}) async {
    if (isVideo) {
      final XFile? picked = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (picked != null) {
        setState(() {
          _mediaFiles.add(picked);
          _mediaTypes.add('video');
        });
      }
    } else {
      final List<XFile>? pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null && pickedImages.isNotEmpty) {
        setState(() {
          _mediaFiles.addAll(pickedImages);
          _mediaTypes.addAll(
            List.generate(pickedImages.length, (_) => 'image'),
          );
        });
      }
    }
  }

  // Upload multiple media
  Future<List<Map<String, String>>> _uploadAllMedia() async {
    List<Map<String, String>> mediaList = [];

    for (int i = 0; i < _mediaFiles.length; i++) {
      final file = _mediaFiles[i];
      final type = _mediaTypes[i];

      // Create a reference
      final ref = FirebaseStorage.instance.ref().child(
        'apartments/${DateTime.now().toIso8601String()}_${file.name}',
      );

      try {
        // Upload differently based on platform
        if (kIsWeb) {
          final bytes = await file.readAsBytes();
          await ref.putData(
            bytes,
            SettableMetadata(
              contentType: type == 'image' ? 'image/jpeg' : 'video/mp4',
            ),
          );
        } else {
          final f = File(file.path);
          print('Uploading file: ${f.path}');
          await ref.putFile(f);
        }

        final url = await ref.getDownloadURL();
        print('Upload success: $url');
        mediaList.add({'url': url, 'type': type});
      } catch (e) {
        print('Upload failed for ${file.name}: $e');
      }
    }

    return mediaList;
  }

  // Add apartment to Firestore with multiple media and error handling
  Future<void> _addApartment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_mediaFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one image or video'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() => isLoading = true);

    try {
      // Upload all media files
      final List<Map<String, String>> mediaList = await _uploadAllMedia();

      if (mediaList.isEmpty) {
        throw Exception("All media uploads failed. Please try again.");
      }

      // Warn user if some media failed
      if (mediaList.length < _mediaFiles.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Warning: ${_mediaFiles.length - mediaList.length} media file(s) failed to upload.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }

      // Add apartment to Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('apartments')
          .add({
            'name': name,
            'location': location,
            'price': price,
            'description': description,
            'available': available,
            'media': mediaList,
            'features': [], // empty for now
            'createdAt': FieldValue.serverTimestamp(),
          });

      debugPrint("Apartment added with ID: ${docRef.id}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Apartment added successfully!'),
              ],
            ),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );

        _formKey.currentState!.reset();
        setState(() {
          _mediaFiles.clear();
          _mediaTypes.clear();
          available = true;
        });
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase Error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),

          _buildSectionTitle('Basic Information'),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Apartment Name',
            icon: Icons.apartment,
            hint: 'e.g., Sunset Villa',
            onSaved: (v) => name = v!,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Location',
            icon: Icons.location_on,
            hint: 'e.g., Diani Beach, Mombasa',
            onSaved: (v) => location = v!,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Price per Night (KSh)',
            icon: Icons.payments,
            hint: 'e.g., 5000',
            keyboardType: TextInputType.number,
            onSaved: (v) => price = double.parse(v!),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Description',
            icon: Icons.description,
            hint: 'Describe the apartment features...',
            maxLines: 4,
            onSaved: (v) => description = v!,
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Availability'),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            child: SwitchListTile(
              title: const Text(
                'Available for Booking',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              subtitle: Text(
                available
                    ? 'Guests can book this apartment'
                    : 'This apartment is not available',
                style: const TextStyle(fontSize: 13),
              ),
              value: available,
              activeThumbColor: const Color(0xFF2E7D32),
              onChanged: (val) => setState(() => available = val),
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Media'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMediaButton(
                  icon: Icons.image,
                  text: 'Pick Image',
                  isVideo: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMediaButton(
                  icon: Icons.video_library,
                  text: 'Pick Video',
                  isVideo: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_mediaFiles.isNotEmpty) _buildMediaPreview(),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
                  )
                : ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_upload, size: 22),
                    label: const Text(
                      'Add Apartment',
                      style: TextStyle(fontSize: 17),
                    ),
                    onPressed: _addApartment,
                    style: ElevatedButton.styleFrom(elevation: 3),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 0,
      color: const Color(0xFF2E7D32).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_home, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Apartment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Fill in the details below',
                    style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF66BB6A)),
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String text,
    required bool isVideo,
  }) => OutlinedButton.icon(
    onPressed: () => _pickMedia(isVideo: isVideo),
    icon: Icon(icon),
    label: Text(text),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      side: const BorderSide(color: Color(0xFF66BB6A)),
      foregroundColor: const Color(0xFF2E7D32),
    ),
  );

  Widget _buildMediaPreview() {
    if (_mediaFiles.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(_mediaFiles.length, (index) {
        final file = _mediaFiles[index];
        final type = _mediaTypes[index];

        return Stack(
          children: [
            Card(
              elevation: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: type == 'image'
                    ? kIsWeb
                          ? Image.network(
                              file.path,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(file.path),
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                    : Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.videocam,
                          size: 50,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _mediaFiles.removeAt(index);
                    _mediaTypes.removeAt(index);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
