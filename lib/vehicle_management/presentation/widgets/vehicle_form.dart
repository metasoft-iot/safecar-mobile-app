import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/vehicle_management/domain/model/vehicle_model.dart';
import 'package:safecar_mobile_app/vehicle_management/infrastructure/mock_vehicle_data.dart';


/// Formulario reutilizable para:
/// - Crear un nuevo vehículo
/// - Editar un vehículo existente (cuando se pasa [initialVehicle])
///
/// Si [initialVehicle] es null → modo "crear".
/// Si [initialVehicle] tiene valor → modo "editar".
class VehicleForm extends StatefulWidget {
  final VehicleModel? initialVehicle;

  const VehicleForm({
    super.key,
    this.initialVehicle,
  });

  /// Indica si el formulario está en modo edición.
  bool get isEditing => initialVehicle != null;

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();

  // ─────────────────────────────────────────────────────────────────────────────
  // Controllers de campos de texto
  // ─────────────────────────────────────────────────────────────────────────────
  final _plateCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _odometerCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _vinCtrl = TextEditingController();
  final _nicknameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  // ─────────────────────────────────────────────────────────────────────────────
  // Estado de selects / switches
  // ─────────────────────────────────────────────────────────────────────────────
  String? _make;
  String? _model;
  String _unit = 'km';
  FuelType _fuel = FuelType.gas;
  bool _isPrimary = false;

  // Marcas y modelos disponibles (mock)
  final Map<String, List<String>> _makesModels = const {
    'Toyota': ['Camry', 'RAV4', 'Corolla', 'Hilux'],
    'Ford': ['Explorer', 'F-150', 'Focus'],
    'Chevrolet': ['Silverado', 'Onix', 'Tahoe'],
    'Honda': ['Civic', 'CR-V', 'Accord'],
    'Nissan': ['Sentra', 'X-Trail', 'Frontier'],
  };

  // Paleta fija de colores para el selector
  final List<Color> _colorOptions = const [
    Color(0xFF111827), // Black
    Color(0xFF4B5563), // Dark Gray
    Color(0xFF9CA3AF), // Silver
    Color(0xFFFFFFFF), // White
    Color(0xFF1F2937), // Midnight Black
    Color(0xFF1D4ED8), // Blue
    Color(0xFF16A34A), // Green
    Color(0xFFDC2626), // Red
  ];

  // ─────────────────────────────────────────────────────────────────────────────
  // Ciclo de vida
  // ─────────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();


    final v = widget.initialVehicle;
    if (v != null) {
      _plateCtrl.text = v.licensePlate;
      _yearCtrl.text = v.year.toString();
      _odometerCtrl.text = v.mileage.toStringAsFixed(0);
      _colorCtrl.text = v.color;
      _vinCtrl.text = v.vin ?? '';
      _nicknameCtrl.text = v.nickname ?? '';
      _notesCtrl.text = '';

      _make = v.make;
      _model = v.model;
      _fuel = v.fuelType;
      _isPrimary = v.isPrimary;
      _unit = 'km';
    }
  }


  @override
  void dispose() {
    _plateCtrl.dispose();
    _yearCtrl.dispose();
    _odometerCtrl.dispose();
    _colorCtrl.dispose();
    _vinCtrl.dispose();
    _nicknameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Validadores
  // ─────────────────────────────────────────────────────────────────────────────
  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _validatePlate(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final norm = v.trim().toUpperCase();
    final ok = RegExp(r'^[A-Z0-9-]{5,10}$').hasMatch(norm);
    return ok ? null : 'Invalid plate';
  }

  String? _validateYear(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    final year = int.tryParse(v);
    final now = DateTime.now().year + 1;
    if (year == null || year < 1980 || year > now) {
      return 'Year 1980–$now';
    }
    return null;
  }

  String? _validateVIN(String? v) {
    if (v == null || v.isEmpty) return null; // opcional
    final ok = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$').hasMatch(v.toUpperCase());
    return ok ? null : 'VIN must be 17 chars (no I,O,Q)';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Lógica de color
  // ─────────────────────────────────────────────────────────────────────────────
  Future<void> _pickColor() async {
    final c = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select color'),
        content: SizedBox(
          width: 320,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _colorOptions
                .map(
                  (color) => GestureDetector(
                onTap: () => Navigator.pop(context, color),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (c != null) {
      setState(() => _colorCtrl.text = _colorName(c));
    }
  }

  String _colorName(Color c) {
    if (c == const Color(0xFF111827)) return 'Black';
    if (c == const Color(0xFF4B5563)) return 'Dark Gray';
    if (c == const Color(0xFF9CA3AF)) return 'Silver';
    if (c == const Color(0xFFFFFFFF)) return 'White';
    if (c == const Color(0xFF1F2937)) return 'Midnight Black';
    if (c == const Color(0xFF1D4ED8)) return 'Blue';
    if (c == const Color(0xFF16A34A)) return 'Green';
    if (c == const Color(0xFFDC2626)) return 'Red';
    return 'Custom';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Guardar formulario (crear o actualizar)
  // ─────────────────────────────────────────────────────────────────────────────

  void _save() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final isEditing = widget.initialVehicle != null;


    final String id = isEditing
        ? widget.initialVehicle!.id
        : 'VH-${(MockVehicleData.vehicles.length + 1).toString().padLeft(3, '0')}';

    final model = VehicleModel(
      id: id,
      make: _make!,
      model: _model!,
      year: int.parse(_yearCtrl.text),
      color: _colorCtrl.text.isEmpty ? 'Black' : _colorCtrl.text,
      licensePlate: _plateCtrl.text.trim().toUpperCase(),
      vin: _vinCtrl.text.trim().isEmpty
          ? null
          : _vinCtrl.text.trim().toUpperCase(),
      mileage: double.tryParse(_odometerCtrl.text.replaceAll(',', '')) ?? 0,
      fuelType: _fuel,
      nickname: _nicknameCtrl.text.trim().isEmpty
          ? null
          : _nicknameCtrl.text.trim(),
      isPrimary: _isPrimary,

      imageUrl: widget.initialVehicle?.imageUrl ??
          'https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg',
    );


    if (_isPrimary) {
      for (var i = 0; i < MockVehicleData.vehicles.length; i++) {
        final v = MockVehicleData.vehicles[i];
        MockVehicleData.vehicles[i] = VehicleModel(
          id: v.id,
          make: v.make,
          model: v.model,
          year: v.year,
          color: v.color,
          licensePlate: v.licensePlate,
          vin: v.vin,
          mileage: v.mileage,
          fuelType: v.fuelType,
          nickname: v.nickname,
          isPrimary: v.id == id, // solo este queda en true
          imageUrl: v.imageUrl,
        );
      }
    }

    if (isEditing) {
      // 🔁 actualizar en la lista
      final idx =
      MockVehicleData.vehicles.indexWhere((v) => v.id == id);
      if (idx != -1) {
        MockVehicleData.vehicles[idx] = model;
      }
    } else {
      // ➕ agregar nuevo
      MockVehicleData.add(model);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? 'Vehicle updated successfully'
              : 'Vehicle saved successfully',
        ),
      ),
    );

    Navigator.of(context).pop(); // volvemos a la lista
  }


  // ─────────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Required Information'),
          const SizedBox(height: 8),
          _card(
            child: Column(
              children: [
                // License Plate
                TextFormField(
                  controller: _plateCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'License Plate*',
                    hintText: 'e.g., ABC-123',
                  ),
                  validator: _validatePlate,
                ),
                const SizedBox(height: 12),

                // Make / Model
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _make,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Make*',
                          hintText: 'Select Make',
                        ),
                        items: _makesModels.keys
                            .map<DropdownMenuItem<String>>(
                              (m) => DropdownMenuItem<String>(
                            value: m,
                            child: Text(m),
                          ),
                        )
                            .toList(),
                        validator: (v) => v == null ? 'Required' : null,
                        onChanged: (v) {
                          setState(() {
                            _make = v;
                            _model = null; // al cambiar marca, reseteamos modelo
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _model,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Model*',
                          hintText: 'Select Model',
                        ),
                        items: (_make == null
                            ? <String>[]
                            : _makesModels[_make] ?? const <String>[])
                            .map<DropdownMenuItem<String>>(
                              (m) => DropdownMenuItem<String>(
                            value: m,
                            child: Text(m),
                          ),
                        )
                            .toList(),
                        validator: (v) => v == null ? 'Required' : null,
                        onChanged: (v) => setState(() => _model = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Year / Color
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Model Year*',
                          hintText: 'e.g., 2023',
                        ),
                        validator: _validateYear,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _colorCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Color*',
                          hintText: 'Select color',
                          suffixIcon: Icon(Icons.color_lens),
                        ),
                        validator: _required,
                        onTap: _pickColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Odometer + unidad
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _odometerCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Odometer*',
                          hintText: 'e.g., 50,000',
                        ),
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _unit,
                        decoration:
                        const InputDecoration(labelText: 'Unit'),
                        items: const [
                          DropdownMenuItem(
                            value: 'km',
                            child: Text('km'),
                          ),
                          DropdownMenuItem(
                            value: 'mi',
                            child: Text('mi'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _unit = v ?? 'km'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Fuel Type
                DropdownButtonFormField<FuelType>(
                  value: _fuel,
                  decoration:
                  const InputDecoration(labelText: 'Fuel Type*'),
                  items: FuelType.values
                      .map<DropdownMenuItem<FuelType>>(
                        (f) => DropdownMenuItem<FuelType>(
                      value: f,
                      child: Text(
                        f.name[0].toUpperCase() + f.name.substring(1),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (v) => setState(() {
                    _fuel = v ?? FuelType.gas;
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _sectionTitle('Optional Information'),
          const SizedBox(height: 8),
          _card(
            child: Column(
              children: [
                // VIN
                TextFormField(
                  controller: _vinCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'VIN',
                    hintText: '17-CHARACTER VIN',
                  ),
                  validator: _validateVIN,
                ),
                const SizedBox(height: 12),

                // Nickname
                TextFormField(
                  controller: _nicknameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Nickname',
                    hintText: 'e.g., My Work Truck',
                  ),
                ),
                const SizedBox(height: 12),

                // Set as primary vehicle
                SwitchListTile.adaptive(
                  value: _isPrimary,
                  title: const Text('Set as primary vehicle'),
                  onChanged: (v) => setState(() => _isPrimary = v),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 12),

                // Photos (placeholder visual)
                _uploadPlaceholder(),
                const SizedBox(height: 12),

                // Notes
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Add any notes about the vehicle…',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(widget.isEditing ? 'Save Changes' : 'Save Vehicle'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helpers de UI
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: child,
    );
  }

  Widget _uploadPlaceholder() {
    return DottedBorder(
      color: Colors.black26,
      strokeWidth: 1.2,
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      dashPattern: const [6, 4],
      child: Container(
        height: 140,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.camera_alt_outlined, size: 28),
            SizedBox(height: 8),
            Text('Upload a file or drag and drop'),
            Text(
              'PNG, JPG up to 5MB',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}


class DottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;
  final BorderType borderType;
  final Radius radius;

  const DottedBorder({
    super.key,
    required this.child,
    this.color = Colors.black26,
    this.strokeWidth = 1.0,
    this.dashPattern = const [5, 3],
    this.borderType = BorderType.RRect,
    this.radius = const Radius.circular(8),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashPattern: dashPattern,
        radius: radius,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(radius),
        child: child,
      ),
    );
  }
}

enum BorderType { RRect }

class _DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;
  final Radius radius;

  _DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashPattern,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromLTRBR(0, 0, size.width, size.height, radius);
    final path = Path()..addRRect(rect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double dashOn = dashPattern[0];
    double dashOff = dashPattern[1];
    double distance = 0.0;
    final metrics = path.computeMetrics().toList();

    for (final metric in metrics) {
      while (distance < metric.length) {
        final len = dashOn.clamp(0, metric.length - distance);
        final extract = metric.extractPath(distance, distance + len);
        canvas.drawPath(extract, paint);
        distance += dashOn + dashOff;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
