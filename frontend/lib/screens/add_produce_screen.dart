import 'package:flutter/material.dart';
import '../models/produce.dart';
import '../services/app_state.dart';
import '../theme.dart';
import 'market_prices_screen.dart';

class AddProduceScreen extends StatefulWidget {
  const AddProduceScreen({super.key});

  @override
  State<AddProduceScreen> createState() => _AddProduceScreenState();
}

class _AddProduceScreenState extends State<AddProduceScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedCrop = 'Tomato';
  String _selectedGrade = 'Grade A (Premium / Export)';
  final _varietyController = TextEditingController();
  final _quantityController = TextEditingController();
  final _shelfLifeController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _harvestDate = DateTime.now();

  final List<String> _crops = [
    'Tomato',
    'Green Chilli',
    'Onion',
    'Paddy',
    'Cotton',
    'Banana',
    'Turmeric',
  ];

  final List<String> _grades = [
    'Grade A (Premium / Export)',
    'Grade B (Standard Market)',
    'Grade C (Processing Only)',
  ];

  @override
  void dispose() {
    _varietyController.dispose();
    _quantityController.dispose();
    _shelfLifeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitProduce() {
    if (_formKey.currentState?.validate() ?? false) {
      // Extract just "Grade A" / "Grade B" / "Grade C" from the full dropdown label
      final gradeParts = _selectedGrade.split(' ');
      final gradeShort = gradeParts.length >= 2
          ? '${gradeParts[0]} ${gradeParts[1]}'
          : _selectedGrade;

      final newProduce = Produce(
        id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
        crop: _selectedCrop,
        variety: _varietyController.text.trim(),
        quantityKg: double.tryParse(_quantityController.text.trim()) ?? 1000.0,
        qualityGrade: gradeShort,
        harvestDate: _harvestDate,
        shelfLifeDays: int.tryParse(_shelfLifeController.text.trim()) ?? 4,
        location: _locationController.text.trim(),
        notes: _notesController.text.trim(),
      );

      // Sync to backend and reload recommendation
      AppState().addProduceWithSync(newProduce);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${newProduce.quantityKg.toInt()} kg ${newProduce.crop} added successfully! Generating Market Insights...'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );

      // Navigate to Market Price Intelligence & Buyer Marketplace
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const MarketPricesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Produce / Harvest'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.paleGreen,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded,
                        color: AppTheme.primaryGreen, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Provide harvest details. SYE will compute real mandi comparisons, buyer capacities, and optimal selling allocations.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.darkGreen,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Crop Selection Dropdown
              const Text(
                'Select Commodity / Crop *',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedCrop,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.eco_rounded,
                      color: AppTheme.primaryGreen),
                ),
                items: _crops.map((crop) {
                  return DropdownMenuItem(value: crop, child: Text(crop));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCrop = val);
                },
              ),
              const SizedBox(height: 16),

              // Variety / Hybrid Name
              const Text(
                'Crop Variety / Seed Hybrid',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _varietyController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined,
                      color: AppTheme.primaryGreen),
                  hintText: 'e.g., Hybrid Vaishnavi, Local Desi',
                ),
              ),
              const SizedBox(height: 16),

              // Quantity & Shelf Life Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Quantity (kg) *',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.scale_rounded,
                                color: AppTheme.primaryGreen),
                            suffixText: 'kg',
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Enter quantity';
                            }
                            if (double.tryParse(val) == null) {
                              return 'Invalid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shelf Life (Days) *',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _shelfLifeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.timer_outlined,
                                color: AppTheme.primaryGreen),
                            suffixText: 'days',
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Enter shelf life';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quality / Grade
              const Text(
                'Quality Grade *',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedGrade,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.verified_outlined,
                      color: AppTheme.primaryGreen),
                ),
                items: _grades.map((grade) {
                  return DropdownMenuItem(value: grade, child: Text(grade));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedGrade = val);
                },
              ),
              const SizedBox(height: 16),

              // Harvest Date & Farm Location Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harvest Date',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _harvestDate,
                              firstDate: DateTime.now().subtract(const Duration(days: 30)),
                              lastDate: DateTime.now().add(const Duration(days: 30)),
                            );
                            if (picked != null) {
                              setState(() => _harvestDate = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined,
                                    size: 18, color: AppTheme.primaryGreen),
                                const SizedBox(width: 8),
                                Text(
                                  '${_harvestDate.day}/${_harvestDate.month}/${_harvestDate.year}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Farm Location *',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.pin_drop_outlined,
                                color: AppTheme.primaryGreen),
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Notes / Special condition
              const Text(
                'Additional Notes (Optional)',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'e.g. Graded and packed in 25kg crates',
                ),
              ),
              const SizedBox(height: 28),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitProduce,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_rounded),
                      SizedBox(width: 8),
                      Text(
                        'Find Best Markets & Buyers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
