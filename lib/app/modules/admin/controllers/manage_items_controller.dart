import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/item_model.dart';
import '../../shared/controllers/items_sync_controller.dart';
import '../../../core/constants/app_constants.dart';

class ManageItemsController extends GetxController {
  final _sync = Get.find<ItemsSyncController>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final selectedCategory = 'Cup'.obs;
  final pickedImagePath = ''.obs;
  final isPickedImageAnAsset = true.obs;
  final isLoading = false.obs;
  final editingId = Rx<int?>(null);
  final categories = ['Cup', 'Bowl', 'Smoothie', 'Special'];

  RxList<ItemModel> get items => _sync.items;

  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final picker = ImagePicker();
      final xfile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (xfile != null) {
        if (kIsWeb) {
          final bytes = await xfile.readAsBytes();
          final base64Str = base64Encode(bytes);
          pickedImagePath.value = 'data:image/jpeg;base64,$base64Str';
        } else {
          pickedImagePath.value = xfile.path;
        }
        isPickedImageAnAsset.value = false;
      }
    } catch (e) {
      Get.snackbar(
        'Image Picker Error',
        'Could not access image: $e',
        backgroundColor: AppColors.strawberryRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void removeImage() {
    pickedImagePath.value = '';
    isPickedImageAnAsset.value = true;
  }

  void startEdit(ItemModel item) {
    editingId.value = item.id;
    nameController.text = item.name;
    priceController.text = item.price.toStringAsFixed(0);
    descController.text = item.description;
    selectedCategory.value = item.category;
    pickedImagePath.value = item.imagePath;
    isPickedImageAnAsset.value = item.isAsset;
  }

  void clearForm() {
    editingId.value = null;
    nameController.clear();
    priceController.clear();
    descController.clear();
    selectedCategory.value = 'Cup';
    pickedImagePath.value = '';
    isPickedImageAnAsset.value = true;
  }

  Future<void> saveItem() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final String imagePath;
      final bool isAsset;

      if (pickedImagePath.value.isNotEmpty) {
        imagePath = pickedImagePath.value;
        isAsset = isPickedImageAnAsset.value;
      } else {
        imagePath = 'assets/images/item_mango_cup.jpg';
        isAsset = true;
      }

      final item = ItemModel(
        id: editingId.value,
        name: nameController.text.trim(),
        price: double.tryParse(priceController.text.trim()) ?? 0,
        description: descController.text.trim(),
        category: selectedCategory.value,
        imagePath: imagePath,
        isAsset: isAsset,
      );

      if (editingId.value != null) {
        await _sync.updateItem(item);
        Get.snackbar(
          'Updated! ✏️',
          '${item.name} has been updated successfully',
          backgroundColor: AppColors.leafGreen,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      } else {
        await _sync.addItem(item);
        Get.snackbar(
          'Added! 🎉',
          '${item.name} has been added to menu',
          backgroundColor: AppColors.leafGreen,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
      clearForm();
    } catch (e) {
      Get.snackbar(
        'Database Error',
        'Could not save item: $e',
        backgroundColor: AppColors.strawberryRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteItem(ItemModel item) async {
    final confirmed = await Get.dialog<bool>(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Delete Item?'),
      content: Text('Remove "${item.name}" from menu?'),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.strawberryRed),
          child: const Text('Delete'),
        ),
      ],
    ));
    if (confirmed == true && item.id != null) {
      await _sync.deleteItem(item.id!);
      Get.snackbar(
        'Deleted',
        '${item.name} removed from menu',
        backgroundColor: AppColors.strawberryRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    super.onClose();
  }
}
