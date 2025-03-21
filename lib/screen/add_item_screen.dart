import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'package:smartstock/widgets/my_filled_button.dart';
import 'package:smartstock/widgets/my_navigation_button.dart';
import 'package:smartstock/widgets/my_outline_button.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _itemTypeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController() ;
  String? selectedImage;
  String selectedItemType = "";
  List<String> itemTypes = [
    "Drink",
    "Medicine",
    "Dairy Product",
    "Bakery",
    "Frozen Food",
    "Snacks",
    "Fruits & Vegetables",
    "Meat & Poultry",
    "Seafood",
    "Cooking Oil",
    "Spices",
    "Pet Supplies",
    "Other",
  ];

  /// Custom Date Picker using Bottom Sheet
  Future<void> _showCustomDatePicker(TextEditingController controller) async {
    DateTime selectedDate = DateTime.now();
    await showModalBottomSheet(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),

              /// Calendar Picker
              SizedBox(
                height: 250,
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
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
                   MyOutlineButton(btnText: 'Cancel',
                     onPressed: () {
                       Navigator.pop(context);
                   },
                     btnTextSize: 15,
                     btnBackground: Colors.white,
                     btnTextColor: Colors.black45,
                     borderColor: Colors.black45,
                   ),
                   MyFilledButton(btnText: 'Confirm date',
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
               Text(
                "Select Image Source",
                style: myTextStyle18(),
              ),
              const Divider(),

              /// Option: Pick from Camera
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title:  Text("Take a photo" , style: myTextStyle15(),),
                onTap: () {
                  Navigator.pop(context);
                  _imagePick(ImageSource.camera);
                },
              ),

              /// Option: Pick from Gallery
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title:  Text("Choose from gallery" , style: myTextStyle15(),),
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
    final XFile? pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage.path;
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
            onPressed: () {},
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
                  child: selectedImage == null
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
                    borderRadius: BorderRadius.circular(12), // Add rounded corners
                    child: Image.file(
                      File(selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
        
              const SizedBox(width: 12),
             /// item name
              _buildInfoField("Item Name", _itemNameController),

              /// Quantity
              _buildInfoField("Quantity", _quantityController),

              /// Item Type
              _buildDropdownField("Item type") ,
        

        
              /// Purchase Date (Custom Date Picker)
              _buildDatePickerField("Purchased Date", _purchaseDateController),
        
              /// Expiry Date (Custom Date Picker)
              _buildDatePickerField("Expires on", _expiryDateController),
        
              const SizedBox(height: 10),
              const Text(
                "*Please confirm or change the expiry date as mentioned on the item!",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),

        
              /// Add Item Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Add this item",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter here",
                  hintStyle: TextStyle(color: Colors.black45),
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
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () => _showCustomDatePicker(controller),
              child: Row(
                children: [
                  Text(
                    controller.text.isEmpty ? "Select date" : controller.text,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
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

  /// Custom Widget for Dropdown using Bottom Sheet
  Widget _buildDropdownField(String label) {
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
          onTap: () => _showItemTypeBottomSheet(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    selectedItemType ?? "Select item type",
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          selectedItemType == null
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Item Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              /// List of item types
              Expanded(
                child: ListView.builder(
                  itemCount: itemTypes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(itemTypes[index]),
                      trailing:
                          selectedItemType == itemTypes[index]
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                      onTap: () {
                        setState(() {
                          selectedItemType = itemTypes[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    super.dispose();
    _itemNameController.dispose();
    _quantityController.dispose();
  }
}
