import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

class AddressForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const AddressForm({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          const Text(
            "Address",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (context.isMobile) ...[
            _buildNameField(),
            _buildMobileField(),
            _buildAddress1(),
            _buildDistrictField(),
            _buildStateField(),
            _buildPincodeField(),
          ] else ...[
            Row(
              children: [
                Expanded(child: _buildNameField()),
                const SizedBox(width: 20),
                Expanded(child: _buildMobileField()),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildAddress1()),
                const SizedBox(width: 20),
                Expanded(child: _buildDistrictField()),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildStateField()),
                const SizedBox(width: 20),
                Expanded(child: _buildPincodeField()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Name',
        hintText: 'e.g., John Doe',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "Please enter name";
        if (value.length < 3) return "Name must be at least 3 characters";
        return null;
      },
    );
  }

  TextFormField _buildMobileField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Mobile no.',
        hintText: 'e.g., 9876543210',
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter mobile number";
        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
          return "Enter a valid 10-digit mobile number";
        }
        return null;
      },
    );
  }

  TextFormField _buildAddress1() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Address Line 1',
        hintText: 'e.g., 123, Main Street',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter address";
        }
        if (value.length < 5) return "Address must be at least 5 characters";
        return null;
      },
    );
  }

  TextFormField _buildDistrictField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'District',
        hintText: 'e.g., Chennai',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter district";
        }
        return null;
      },
    );
  }

  TextFormField _buildStateField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'State',
        hintText: 'e.g., Tamil Nadu',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "Please enter state";
        return null;
      },
    );
  }

  TextFormField _buildPincodeField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Pincode',
        hintText: 'e.g., 600001',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter pincode";
        if (!RegExp(r'^\d{6}$').hasMatch(value)) {
          return "Enter a valid 6-digit pincode";
        }
        return null;
      },
    );
  }
}
