import 'package:codingo/core/widget/image_network_widget.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_search_field.dart';
import 'package:codingo/views/user_discover/model/profile_model.dart';
import 'package:codingo/views/user_discover/service/discover_service.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomSearchDropdown extends StatefulWidget {
  const CustomSearchDropdown({Key? key, required this.onTap}) : super(key: key);
  final void Function(String username) onTap;
  @override
  State<CustomSearchDropdown> createState() => _CustomSearchDropdownState();
}

class _CustomSearchDropdownState extends State<CustomSearchDropdown> {
  String _searchText = '';
  List<SearchFieldListItem> _searchFieldItems = [];
  late final TextEditingController _controller;
  late final DiscoverService _service;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _service = DiscoverService();
    () async {
      await getProfiles();
    }();
  }

  Future<void> getProfiles() async {
    final List<ProfileModel> result = await _service.getProfileList();
    _searchFieldItems = result
        .map((user) => SearchFieldListItem(
              user.realName,
              child: user.pictureSrc == ''
                  ? ImagePaths.unknown.toWidget()
                  : ImageNetworkWidget(pictureSrc: user.pictureSrc),
              item: user.username
            ))
        .toList();
  }

  List<SearchFieldListItem> getFilteredSuggestions() {
    if (_searchText.isNotEmpty) {
      final searchLower = _searchText.toLowerCase();
      return _searchFieldItems.where((item) {
        final itemLower = item.searchKey.toLowerCase();
        return itemLower.contains(searchLower);
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final filteredSuggestions = getFilteredSuggestions();
    final device = MediaQuery.of(context).size;
    return Column(
      children: [
        CustomSearchField(
          controller: _controller,
          hintText: 'Kullanıcı Adı',
          prefixIcon: ImagePaths.search_icon.toWidget(height: 18),
          hasSuffixIcon: false,
          inputAction: TextInputAction.search,
          autoFillHints: const [AutofillHints.nickname],
          textInputType: TextInputType.name,
          onChange: (p0) {
            setState(() {
              _searchText = p0;
            });
          },
        ),
        _searchText.isNotEmpty ? Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: _DropdownStyles.borderColor))
          ),
          width: device.width,
          height: device.height * .4,
          child: ListView.builder(
            itemCount: filteredSuggestions.length,
            itemBuilder: (context, index) {
              final suggestion = filteredSuggestions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: ListTile(
                  style: ListTileStyle.list,
                  title: Text(suggestion.searchKey),
                  leading: SizedBox(
                    width: device.width * .125,
                    height: device.width * .125,
                    child: suggestion.child,
                  ),
                  minLeadingWidth: device.width * .15,
                  titleTextStyle: const TextStyle(
                    fontFamily: FontTheme.fontFamily,
                    fontSize: FontTheme.fontSize,
                    fontWeight: FontTheme.rfontWeight,
                    color: _DropdownStyles.titleColor
                  ),
                  onTap: () {
                    widget.onTap(suggestion.item);
                  },
                ),
              );
            },
          ),
        ) : const SizedBox.shrink(),
      ],
    );
  }
}

class _DropdownStyles {
  static const Color borderColor = Color.fromRGBO(202, 202, 202, 1);
  static const Color titleColor = Color.fromRGBO(23, 23, 23, 1);
}