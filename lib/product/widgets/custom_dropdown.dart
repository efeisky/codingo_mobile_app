import 'package:codingo/product/enum/dropdown_enums.dart';
import 'package:codingo/product/model/json_model.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/views/register/feature/theme/register_theme.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({Key? key, required this.hint, required this.type, required this.onSelected, required this.onChangedSelected, this.provinceAndEduLevel, required this.inputAction}) : super(key: key);
  final String hint;
  final DropdownTypes type;
  final TextInputAction inputAction;
  final Map? provinceAndEduLevel;  
  final void Function(String value) onSelected;
  final void Function() onChangedSelected;
  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  
  late List<SearchFieldListItem<String>> _searchFieldItems;
  bool _isSelected = false;
  bool? _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _searchFieldItems = [];
    _checkDropdownType();
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.provinceAndEduLevel != null && widget.type == DropdownTypes.school && _isProcessing == false) {
      final province = widget.provinceAndEduLevel!['province'];
      final eduLevel = widget.provinceAndEduLevel!['eduLevel'];
      _getSchoolList(province,eduLevel);
    }
  }

  void _checkDropdownType() {
    if(widget.type == DropdownTypes.province){
      _getProvinceList();
    }
    else if(widget.type == DropdownTypes.education){
      _searchFieldItems = [
        SearchFieldListItem('1'),
        SearchFieldListItem('2'),
        SearchFieldListItem('3'),
        SearchFieldListItem('4'),
        SearchFieldListItem('5'),
        SearchFieldListItem('6'),
        SearchFieldListItem('7'),
        SearchFieldListItem('8'),
        SearchFieldListItem('9'),
        SearchFieldListItem('10'),
        SearchFieldListItem('11'),
        SearchFieldListItem('12'),
        SearchFieldListItem('Mezun')
      ];
    }
  }

  Future<void> _getProvinceList() async {
    ProvinceModel provinceModel = ProvinceModel();
    final result = await provinceModel.getProvinceList();
    
    _searchFieldItems = result.map((province) {
      return SearchFieldListItem<String>(province.name!);
    }).toList();
    setState(() {});
  }

  Future<void> _getSchoolList(String province, String eduLevel) async {
    _isProcessing = true;
    SchoolModel schoolModel = SchoolModel();
    final result = await schoolModel.getSchoolList(province,eduLevel);
    _searchFieldItems = result.map((school) {
      return SearchFieldListItem<String>(school.name!);
    }).toList();
    _isProcessing = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.hint,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: FontTheme.fontFamily,
                    fontSize: FontTheme.nbfontSize,
                    color: RegisterTheme.dropdownUpperHintTextColor,
                    fontWeight: FontTheme.xfontWeight
                  ),
                ),
                _isSelected ? const Icon(
                  Icons.done_rounded,
                  color: RegisterTheme.selectedColor,
                ) : const Icon(
                  Icons.error_outline_rounded,
                  color: RegisterTheme.errorColor,
                  )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SearchField(
              textInputAction: widget.inputAction,
              searchInputDecoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueGrey.shade200
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueGrey.withOpacity(0.8)
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              itemHeight: 50,
              maxSuggestionsInViewPort: 5,
              onSuggestionTap: (p0) {
                setState(() {
                  _isSelected = true;
                });
                widget.onSelected(p0.searchKey);
              },
              onSearchTextChanged: (p1) {
                if(_isSelected){
                  widget.onChangedSelected();
                  setState(() {
                    _isSelected = false;
                  });
                }
                return _searchFieldItems;
              },
              key: widget.key,
              hint: widget.hint,
              suggestionsDecoration: SuggestionDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              suggestions: _searchFieldItems
            ),
          ),
        ],
      ),
    );
  }
}