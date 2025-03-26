import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/constant/app_constant.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'package:smartstock/utils/image_utils.dart';
import 'package:smartstock/widgets/my_filled_button.dart';
import 'package:smartstock/widgets/my_navigation_button.dart';
import 'package:smartstock/widgets/my_outline_button.dart';
import 'package:smartstock/widgets/my_snack_message.dart';

class AddItemScreen extends StatefulWidget {
  final String? prefilledCategory;
  final String? prefilledItemType;

  const AddItemScreen({
    super.key,
    this.prefilledCategory,
    this.prefilledItemType,
  });

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  String? selectedImage;
  String selectedCategoryType = "";
  String selectedItemType = "";

  @override
  void initState() {
    super.initState();
    selectedCategoryType = widget.prefilledCategory ?? "";
    selectedItemType = widget.prefilledItemType ?? "";
  }

  /// Custom Date Picker using Bottom Sheet
  Future<void> _showCustomDatePicker(TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    await showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              /// Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Select Date",
                  style: myTextStyle18(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),

              /// Calendar Picker
              SizedBox(
                height: 250,
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2100),
                  onDateChanged: (date) {
                    selectedDate = date;
                  },
                ),
              ),

              /// Confirm Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyOutlineButton(
                      btnText: 'Cancel',
                      borderRadius: 8,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      btnTextSize: 15,
                      btnBackground: Colors.white,
                      btnTextColor: Colors.black45,
                      borderColor: Colors.black45,
                    ),
                    MyFilledButton(
                      btnText: 'Select date',
                      borderRadius: 8,
                      onPressed: () {
                        setState(() {
                          controller.text = DateFormat(
                            'dd MMM yyyy',
                          ).format(selectedDate);
                        });
                        Navigator.pop(context);
                      },
                      btnBackground: AppColors.main,
                      btnTextSize: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            children: [
              Text("Select Image Source", style: myTextStyle18()),
              const Divider(),

              /// Option: Pick from Camera
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: Text("Take a photo", style: myTextStyle15()),
                onTap: () {
                  Navigator.pop(context);
                  _imagePick(ImageSource.camera);
                },
              ),

              /// Option: Pick from Gallery
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: Text("Choose from gallery", style: myTextStyle15()),
                onTap: () {
                  Navigator.pop(context);
                  _imagePick(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Function to Pick Image from Camera or Gallery
  void _imagePick(ImageSource source) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: source,
      imageQuality: 80, // Compress image to reduce size
    );
    if (pickedImage != null) {
      // Save image permanently
      final permanentPath = await ImageUtils.saveImagePermanently(pickedImage.path);
      setState(() {
        selectedImage = permanentPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;
    final mqWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      /// ------ Appbar ------- ///
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyNavigationButton(
            btnIcon: Icons.arrow_back_ios_rounded,
            btnBackground: Colors.black12,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text("Add new item", style: myTextStyle24()),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,

      /// ------ body ----- ///
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Item Image
              InkWell(
                onTap: _showImagePickerOptions,
                child: Container(
                  height: mqHeight * 0.2,
                  width: mqHeight * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.secondary.withAlpha(90),
                  ),
                  child:
                      selectedImage == null
                          ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 100,
                                color: Colors.black45,
                              ),
                            ),
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Add rounded corners
                            child: Image.file(
                              File(selectedImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 21),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Fill Details",
                    style: myTextStyle18(
                      fontColor: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              /// item name
              _buildInfoField("Item Name", _itemNameController),

              /// Quantity
              _buildInfoField("Quantity", _quantityController),

              /// Item Type
              if (widget.prefilledCategory == null)
                _buildCategoryDropdownField("Item Categories"),

              /// Item Categories
              if (widget.prefilledItemType == null)
                _buildItemTypeDropdownField("Item Type"),

              /// Purchase Date (Custom Date Picker)
              _buildDatePickerField("Purchased Date", _purchaseDateController),

              /// Expiry Date (Custom Date Picker)
              _buildDatePickerField("Expires on", _expiryDateController),

              const SizedBox(height: 10),
              Text(
                "*Please confirm or change the expiry date as mentioned on the item!",
                style: myTextStyle12(fontColor: Colors.black54),
              ),
              SizedBox(height: 12),

              /// Add Item Button
              SizedBox(
                width: double.infinity,
                child: MyFilledButton(
                  btnText: "+ Add this item",
                  btnBackground: AppColors.main,
                  borderRadius: 8,
                  /// here we add items
                  onPressed: _saveItem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom Widget for Text Input Fields
  Widget _buildInfoField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: myTextStyle15(fontWeight: FontWeight.w500)),
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter here",
                  hintStyle: myTextStyle15(fontColor: Colors.black45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom Widget for Date Picker Fields
  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: myTextStyle15(fontWeight: FontWeight.w500)),
            GestureDetector(
              onTap: () => _showCustomDatePicker(controller),
              child: Row(
                children: [
                  Text(
                    controller.text.isEmpty ? "Select date" : controller.text,
                    style: myTextStyle15(fontColor: Colors.black54),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.black45,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: InkWell(
          onTap: _showItemCategoriesBottomSheet,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: myTextStyle15(fontWeight: FontWeight.w500)),
              Row(
                children: [
                  Text(
                    selectedCategoryType.isEmpty
                        ? "Select"
                        : selectedCategoryType,
                    style: myTextStyle15(
                      fontColor:
                          selectedCategoryType.isEmpty
                              ? Colors.black45
                              : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemCategoriesBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select Item Category",
                style: myTextStyle18(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 11),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryType = "Grocery";
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            selectedCategoryType == "Grocery"
                                ? AppColors.secondary
                                : Colors.white,
                        border: Border.all(
                          width: 2,
                          color:
                              selectedCategoryType == "Grocery"
                                  ? AppColors.secondary
                                  : Colors.black45,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/shopping-bag.png",
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            Text("Grocery", style: myTextStyle18()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryType = "Medicine";
                      });
                      Navigator.pop(context); // Close bottom sheet
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            selectedCategoryType == "Medicine"
                                ? AppColors.secondary
                                : Colors.white,
                        border: Border.all(
                          width: 2,
                          color:
                              selectedCategoryType == "Medicine"
                                  ? AppColors.secondary
                                  : Colors.black45,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/syringe (1).png",
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            Text("Medicine", style: myTextStyle18()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Custom Widget for Dropdown using Bottom Sheet
  Widget _buildItemTypeDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: InkWell(
          onTap: () {
            if (selectedCategoryType.isEmpty) {
              /// here  we call MySnackMessage
              MySnackMessage(
                message: 'First select a category',
                backgroundColor: Colors.red.shade400,
                actionLabel: "Ok",
                labelTextColor: Colors.black54,
                onActionPressed: () {
                  _showItemCategoriesBottomSheet();
                },
              ).show(context);
            } else {
              // Open item type selection if category is selected
              _showItemTypeBottomSheet();
            }
          },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: myTextStyle15(fontWeight: FontWeight.w500)),
              Row(
                children: [
                  Text(
                    selectedItemType.isEmpty ? "Select" : selectedItemType,
                    style: myTextStyle15(
                      fontColor:
                          selectedCategoryType.isEmpty
                              ? Colors.black45
                              : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show Bottom Sheet for Item Type Selection
  void _showItemTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select Item Type",
                style: myTextStyle15(fontWeight: FontWeight.bold),
              ),
              const Divider(),

              /// List of item types
              Expanded(
                child: GridView.builder(
                  itemCount:
                      selectedCategoryType == "Grocery"
                          ? AppConstant.items.length
                          : AppConstant.itemsMed.length,
                  itemBuilder: (context, index) {
                    var myItems =
                        selectedCategoryType == "Grocery"
                            ? AppConstant.items[index]
                            : AppConstant.itemsMed[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedItemType = myItems['title'];
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 2,
                              color:
                                  selectedItemType == myItems['title']
                                      ? AppColors.secondary
                                      : Colors.black45,
                            ),
                            color:
                                selectedItemType == myItems['title']
                                    ? AppColors.secondary
                                    : Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  myItems['image'],
                                  color: AppColors.main,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  fit: BoxFit.cover,
                                ),

                                Text(myItems['title'], style: myTextStyle12()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Save item to Hive database
  Future<void> _saveItem() async {
    if (_itemNameController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _purchaseDateController.text.isEmpty ||
        _expiryDateController.text.isEmpty ||
        selectedCategoryType.isEmpty ||
        selectedItemType.isEmpty) {
      MySnackMessage(
        message: 'Please fill all required fields',
        backgroundColor: Colors.red.shade400,
        actionLabel: "Ok",
        labelTextColor: Colors.black54,
        onActionPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ).show(context);
      return;
    }

    final item = Item(
      itemName: _itemNameController.text,
      quantity: _quantityController.text,
      purchaseDate: _purchaseDateController.text,
      expiryDate: _expiryDateController.text,
      imagePath: selectedImage,
      categoryType: selectedCategoryType,
      itemType: selectedItemType,
    );

    final box = await Hive.openBox<Item>('items');
    await box.add(item);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _purchaseDateController.dispose();
    _expiryDateController.dispose();
    _itemNameController.dispose();
    super.dispose();
  }
}
