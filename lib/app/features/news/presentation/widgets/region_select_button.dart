import 'package:flutter/material.dart';

class RegionSelectButton extends StatefulWidget {
  const RegionSelectButton({super.key, this.onRegionSelected});
  final Function(String)? onRegionSelected;

  @override
  State<RegionSelectButton> createState() => _RegionSelectButtonState();
}

class _RegionSelectButtonState extends State<RegionSelectButton> {
  String _selectedRegion = 'EN';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRegion,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          dropdownColor: Colors.grey[850],
          style: const TextStyle(color: Colors.white, fontSize: 16),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedRegion = value;
              });
              widget.onRegionSelected?.call(value.toLowerCase());
            }
          },
          items: [
            'EN', 'TR', 'DE', 'NL', 'ES', 'FR', 'IT', 'PT', 'RU', 'AR', 'CN', 'JP', 'KO',
          ].map<DropdownMenuItem<String>>((String region) {
            return DropdownMenuItem<String>(
              value: region,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(region),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
