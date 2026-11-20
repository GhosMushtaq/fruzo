import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/manage_items_controller.dart';
import '../controllers/admin_nav_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/fruzo_button.dart';
import '../../../core/widgets/fruzo_image.dart';
import '../../../data/models/item_model.dart';
import '../../../core/utils/helpers.dart';

class ManageItemsView extends StatelessWidget {
  const ManageItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ManageItemsController>();
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: AppBar(
        title: const Text('Manage Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts_rounded),
            onPressed: () => Get.find<AdminNavController>().showChangeCredentialsDialog(context),
            tooltip: 'Account Settings',
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: Get.find<AdminNavController>().logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: c.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Header
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.editingId.value != null ? '✏️ Edit Item' : '➕ Add New Item',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepCharcoal,
                              ),
                            ),
                          ),
                          if (c.editingId.value != null)
                            TextButton.icon(
                              onPressed: c.clearForm,
                              icon: const Icon(Icons.close_rounded, size: 16),
                              label: const Text('Cancel'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.strawberryRed,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Item Name
                    TextFormField(
                      controller: c.nameController,
                      decoration: const InputDecoration(
                        hintText: 'Item Name *',
                        prefixIcon: Icon(Icons.fastfood_rounded, color: AppColors.primaryOrange),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Item name is required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Price
                    TextFormField(
                      controller: c.priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: 'Price (PKR) *',
                        prefixIcon: Icon(Icons.attach_money_rounded, color: AppColors.primaryOrange),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Price is required';
                        if (double.tryParse(v.trim()) == null) return 'Enter a valid numeric price';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Description
                    TextFormField(
                      controller: c.descController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Description (optional)',
                        prefixIcon: Icon(Icons.description_rounded, color: AppColors.primaryOrange),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Category Selection
                    Text(
                      'Category',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepCharcoal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: c.categories.map((cat) {
                          final isSelected = c.selectedCategory.value == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) => c.selectedCategory.value = cat,
                            selectedColor: AppColors.primaryOrange,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.deepCharcoal,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Image Picker Section (Directly observing observables)
                    Text(
                      'Item Image',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepCharcoal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final imagePath = c.pickedImagePath.value;
                      final isAsset = c.isPickedImageAnAsset.value;

                      if (imagePath.isNotEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.creamBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.softPeach, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              // Preview Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 65,
                                  height: 65,
                                  child: FruzoImage(
                                    imagePath: imagePath,
                                    isAsset: isAsset,
                                    fit: BoxFit.cover,
                                    placeholder: _errorPlaceholder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Image Selected',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.deepCharcoal,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isAsset ? 'Default catalog photo' : 'Custom photo',
                                      style: GoogleFonts.nunito(
                                        fontSize: 11,
                                        color: AppColors.mutedGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Actions
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.primaryOrange, size: 20),
                                tooltip: 'Change image',
                                onPressed: () => _showPickerSheet(context, c),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.strawberryRed, size: 20),
                                tooltip: 'Remove image',
                                onPressed: c.removeImage,
                              ),
                            ],
                          ),
                        );
                      }

                      // Empty state
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.creamBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.softPeach, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: AppColors.softPeach,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add_photo_alternate_rounded, color: AppColors.primaryOrange, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Add item photo (Optional)',
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deepCharcoal,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _showPickerSheet(context, c),
                              icon: const Icon(Icons.photo_library_rounded, size: 16),
                              label: const Text('Pick'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryOrange,
                                side: const BorderSide(color: AppColors.primaryOrange),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Submit Button
                    Obx(
                      () => FruzoButton(
                        label: c.editingId.value != null ? 'UPDATE ITEM' : 'ADD ITEM TO MENU',
                        isLoading: c.isLoading.value,
                        onTap: c.saveItem,
                        icon: c.editingId.value != null ? Icons.update_rounded : Icons.add_circle_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 24),

            // Items List Header
            Obx(
              () => Row(
                children: [
                  Text(
                    'Menu Items',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.softPeach,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${c.items.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Items List
            Obx(() {
              if (c.items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 60, color: AppColors.mutedGrey),
                        const SizedBox(height: 12),
                        Text(
                          'No items in menu yet.\nAdd your first fruit cup!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: AppColors.mutedGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: c.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _ItemTile(item: c.items[i], controller: c)
                    .animate()
                    .fadeIn(delay: (i * 40).ms)
                    .slideY(begin: 0.08, end: 0, delay: (i * 40).ms),
              );
            }),
          ],
        ),
      ),
    );
  }

  static void _showPickerSheet(BuildContext context, ManageItemsController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Choose Image Source',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.softPeach,
                  child: Icon(Icons.photo_library_rounded, color: AppColors.primaryOrange),
                ),
                title: Text('Gallery', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                subtitle: const Text('Pick an existing photo'),
                onTap: () {
                  Get.back();
                  controller.pickImage(source: ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.softPeach,
                  child: Icon(Icons.camera_alt_rounded, color: AppColors.primaryOrange),
                ),
                title: Text('Camera', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                subtitle: const Text('Take a new photo with camera'),
                onTap: () {
                  Get.back();
                  controller.pickImage(source: ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _errorPlaceholder() => Container(
        color: AppColors.softPeach,
        child: const Icon(Icons.image_not_supported_rounded, color: AppColors.primaryOrange, size: 28),
      );
}

/// An individual item tile that cannot overflow regardless of screen size or text length.
class _ItemTile extends StatelessWidget {
  final ItemModel item;
  final ManageItemsController controller;
  const _ItemTile({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 55,
              height: 55,
              child: FruzoImage(
                imagePath: item.imagePath,
                isAsset: item.isAsset,
                fit: BoxFit.cover,
                placeholder: _placeholder(),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name and Details (Safe against multi-line overflow)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.category} • ${Helpers.formatPrice(item.price)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // Compact Action Buttons
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => controller.startEdit(item),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.softPeach,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_rounded, color: AppColors.primaryOrange, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => controller.deleteItem(item),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.strawberryRed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_rounded, color: AppColors.strawberryRed, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.softPeach,
        child: const Icon(Icons.fastfood_rounded, color: AppColors.primaryOrange, size: 24),
      );
}
