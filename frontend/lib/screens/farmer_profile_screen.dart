import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  final _appState = AppState();
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _villageController;
  late TextEditingController _districtController;
  late TextEditingController _stateController;
  late TextEditingController _landController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final profile = _appState.farmerProfile;
    _nameController = TextEditingController(text: profile.name);
    _phoneController = TextEditingController(text: profile.phone);
    _villageController = TextEditingController(text: profile.village);
    _districtController = TextEditingController(text: profile.district);
    _stateController = TextEditingController(text: profile.state);
    _landController =
        TextEditingController(text: profile.landSizeAcres.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _landController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updated = _appState.farmerProfile.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      village: _villageController.text.trim(),
      district: _districtController.text.trim(),
      state: _stateController.text.trim(),
      landSizeAcres: double.tryParse(_landController.text) ??
          _appState.farmerProfile.landSizeAcres,
    );
    _appState.updateFarmerProfile(updated);
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Farmer Profile updated successfully!'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = _appState.farmerProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check_circle_rounded : Icons.edit_note_rounded),
            color: AppTheme.primaryGreen,
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Profile Header Card
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFC8E6C9), width: 1),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8F5E9), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.primaryGreen,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkGreen,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                size: 18,
                                color: AppTheme.primaryGreen,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kisan ID: ${profile.kisanId}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📍 ${profile.village}, ${profile.district}, ${profile.state}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Stats Bar
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Land Holding',
                    value: '${profile.landSizeAcres} Acres',
                    icon: Icons.landscape_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    title: 'Member Since',
                    value: profile.memberSince,
                    icon: Icons.calendar_today_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: _StatCard(
                    title: 'KYC Status',
                    value: 'Verified',
                    icon: Icons.security_rounded,
                    isHighlight: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Details & Edit Fields
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Farm & Personal Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          _isEditing ? 'Editing Mode' : 'Read Only',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _isEditing ? AppTheme.goldAccent : AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFF3F4F6)),

                    // Name
                    _ProfileField(
                      label: 'Full Name',
                      controller: _nameController,
                      isEditing: _isEditing,
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 12),

                    // Phone
                    _ProfileField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      isEditing: _isEditing,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),

                    // Village
                    _ProfileField(
                      label: 'Village / Mandi Area',
                      controller: _villageController,
                      isEditing: _isEditing,
                      icon: Icons.home_work_outlined,
                    ),
                    const SizedBox(height: 12),

                    // District
                    _ProfileField(
                      label: 'District',
                      controller: _districtController,
                      isEditing: _isEditing,
                      icon: Icons.location_city_outlined,
                    ),
                    const SizedBox(height: 12),

                    // State
                    _ProfileField(
                      label: 'State',
                      controller: _stateController,
                      isEditing: _isEditing,
                      icon: Icons.map_outlined,
                    ),
                    const SizedBox(height: 12),

                    // Land Size
                    _ProfileField(
                      label: 'Farm Land (in Acres)',
                      controller: _landController,
                      isEditing: _isEditing,
                      icon: Icons.agriculture_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    if (_isEditing)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          child: const Text('Save Profile Changes'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Primary Crops Chip List
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Primary Crops Cultivated',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profile.primaryCrops.map((crop) {
                        return Chip(
                          label: Text(crop),
                          backgroundColor: AppTheme.paleGreen,
                          labelStyle: const TextStyle(
                            color: AppTheme.darkGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          avatar: const Icon(Icons.eco_outlined,
                              size: 16, color: AppTheme.primaryGreen),
                          side: const BorderSide(color: Color(0xFFC8E6C9)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isHighlight;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlight ? AppTheme.lightGreen : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: isHighlight ? AppTheme.primaryGreen : AppTheme.textMuted,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isHighlight ? AppTheme.darkGreen : AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final IconData icon;
  final TextInputType keyboardType;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.isEditing,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.primaryGreen, size: 20),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryGreen),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
            ),
            Text(
              controller.text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
