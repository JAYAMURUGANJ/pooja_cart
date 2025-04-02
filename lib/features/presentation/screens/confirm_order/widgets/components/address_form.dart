import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

class AddressForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController addressController;
  final TextEditingController districtController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;

  const AddressForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.mobileController,
    required this.addressController,
    required this.districtController,
    required this.stateController,
    required this.pincodeController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Shipping Address",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (context.isMobile) ...[
            _buildInputField(
              controller: nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline,
              validator: _validateName,
            ),
            _buildInputField(
              controller: mobileController,
              label: 'Mobile Number',
              hint: '10-digit mobile number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: _validateMobile,
            ),
            _buildInputField(
              controller: addressController,
              label: 'Address Line',
              hint: 'Street address, house number',
              icon: Icons.home_outlined,
              validator: _validateAddress,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: districtController,
                    label: 'District',
                    hint: 'Your district',
                    icon: Icons.location_city_outlined,
                    validator: _validateDistrict,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    controller: pincodeController,
                    label: 'Pincode',
                    hint: '6-digit pincode',
                    icon: Icons.pin_drop_outlined,
                    keyboardType: TextInputType.number,
                    validator: _validatePincode,
                  ),
                ),
              ],
            ),
            _buildInputField(
              controller: stateController,
              label: 'State',
              hint: 'Your state',
              icon: Icons.map_outlined,
              validator: _validateState,
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person_outline,
                    validator: _validateName,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    controller: mobileController,
                    label: 'Mobile Number',
                    hint: '10-digit mobile number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: _validateMobile,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildInputField(
                    controller: addressController,
                    label: 'Address Line',
                    hint: 'Street address, house number',
                    icon: Icons.home_outlined,
                    validator: _validateAddress,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    controller: districtController,
                    label: 'District',
                    hint: 'Your district',
                    icon: Icons.location_city_outlined,
                    validator: _validateDistrict,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: stateController,
                    label: 'State',
                    hint: 'Your state',
                    icon: Icons.map_outlined,
                    validator: _validateState,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    controller: pincodeController,
                    label: 'Pincode',
                    hint: '6-digit pincode',
                    icon: Icons.pin_drop_outlined,
                    keyboardType: TextInputType.number,
                    validator: _validatePincode,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your name";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter mobile number";
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return "Enter a valid 10-digit mobile number";
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your address";
    }
    if (value.length < 5) {
      return "Address must be at least 5 characters";
    }
    return null;
  }

  String? _validateDistrict(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter district";
    }
    return null;
  }

  String? _validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter state";
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter pincode";
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return "Enter a valid 6-digit pincode";
    }
    return null;
  }
}
