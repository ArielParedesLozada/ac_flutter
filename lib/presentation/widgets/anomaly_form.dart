import 'package:acl_flutter/app/dtos/anomaly_create_dto.dart';
import 'package:acl_flutter/domain/enums/anomaly_enums.dart';
import 'package:acl_flutter/domain/models/anomaly.dart';
import 'package:acl_flutter/presentation/widgets/enum_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AnomalyForm extends StatefulWidget {
  final Anomaly? anomaly;
  final void Function(AnomalyCreateDto) onSubmit;

  const AnomalyForm({super.key, this.anomaly, required this.onSubmit});

  @override
  State<AnomalyForm> createState() => _AnomalyFormState();
}

class _AnomalyFormState extends State<AnomalyForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _valueController;
  late final MapController _mapController;
  late AnomalyType _selectedType;
  late AnomalyClass _selectedClass;
  late AnomalyDisruption _selectedDisruption;
  late AnomalyHostility _selectedHostility;
  late AnomalyInfo _selectedInfo;
  late Coordinates? _coordinates;

  @override
  void initState() {
    super.initState();
    final a = widget.anomaly;
    _nameController = TextEditingController(text: a?.name ?? '');
    _phoneController = TextEditingController(text: a?.phone ?? '');
    _valueController = TextEditingController(
      text: a?.value == null ? '' : a?.value?.toString(),
    );
    _selectedType = a?.type ?? AnomalyType.kte;
    _selectedClass = a?.classification ?? AnomalyClass.safe;
    _selectedDisruption = a?.disruption ?? AnomalyDisruption.dark;
    _selectedHostility = a?.hostility ?? AnomalyHostility.notice;
    _selectedInfo = a?.info ?? AnomalyInfo.cernunnos;
    _mapController = MapController();
    _coordinates = a?.coordinates;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _valueController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      AnomalyCreateDto(
        type: _selectedType,
        classification: _selectedClass,
        disruption: _selectedDisruption,
        hostility: _selectedHostility,
        info: _selectedInfo,
        name: _nameController.text.isEmpty ? null : _nameController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        value: _valueController.text.isEmpty
            ? null
            : double.parse(_valueController.text),
        coordinates: _coordinates,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Nombre"),
          ),
          EnumDropdown<AnomalyType>(
            values: AnomalyType.values,
            selectedValue: _selectedType,
            labelText: "Tipo de anomalía",
            hintText: "Seleccione un tipo",
            displayName: (e) => e.name.toUpperCase(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedType = value);
            },
            validator: (value) => value == null ? "Seleccione un tipo" : null,
          ),
          EnumDropdown<AnomalyClass>(
            values: AnomalyClass.values,
            selectedValue: _selectedClass,
            labelText: "Clasificación de la anomalía",
            hintText: "Seleccione una clase",
            displayName: (e) => e.name.toUpperCase(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedClass = value);
            },
            validator: (value) => value == null ? "Seleccione una clase" : null,
          ),
          EnumDropdown<AnomalyDisruption>(
            values: AnomalyDisruption.values,
            selectedValue: _selectedDisruption,
            labelText: "Disrupción de anomalía",
            hintText: "Seleccione la disrupción",
            displayName: (e) => e.name.toUpperCase(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedDisruption = value);
            },
            validator: (value) =>
                value == null ? "Seleccione la disrupción" : null,
          ),
          EnumDropdown<AnomalyHostility>(
            values: AnomalyHostility.values,
            selectedValue: _selectedHostility,
            labelText: "Hostilidad de anomalía",
            hintText: "Seleccione una hostilidad",
            displayName: (e) => e.name.toUpperCase(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedHostility = value);
            },
            validator: (value) =>
                value == null ? "Seleccione la hostilidad" : null,
          ),
          EnumDropdown<AnomalyInfo>(
            values: AnomalyInfo.values,
            selectedValue: _selectedInfo,
            labelText: "Información de la anomalía",
            hintText: "Seleccione el nivel de información",
            displayName: (e) => e.name.toUpperCase(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedInfo = value);
            },
            validator: (value) =>
                value == null ? "Seleccione el nivel de información" : null,
          ),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: "Teléfono/Contacto"),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final phoneRegex = RegExp(
                r'^(\+\d{3}\s\d{2}\s\d{3}\s\d{4})|(0\d{9})$|(\d{7})$|(03\d{7})$',
              );
              if (!phoneRegex.hasMatch(value)) {
                return 'Ingresa un número de teléfono válido';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _valueController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            decoration: const InputDecoration(labelText: "Valor"),
          ),
          Padding(padding: EdgeInsets.all(10), child: const Text("Ubicación")),
          SizedBox(
            height: 300,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: widget.anomaly?.coordinates == null
                    ? LatLng(-1.241667, -78.619720)
                    : LatLng(
                        widget.anomaly!.coordinates!.latitude,
                        widget.anomaly!.coordinates!.longitude,
                      ),
                initialZoom: 9,
                onTap: (tapPosition, point) {
                  setState(() {
                    _coordinates = Coordinates(
                      latitude: point.latitude,
                      longitude: point.longitude,
                    );
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.acl_flutter',
                ),
                if (_coordinates != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          _coordinates!.latitude,
                          _coordinates!.longitude,
                        ),
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _submit, child: const Text('Guardar')),
        ],
      ),
    );
  }
}
