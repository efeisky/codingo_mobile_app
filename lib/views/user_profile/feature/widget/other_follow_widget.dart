import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/views/options_pages/user_follow/feature/error_not_found.dart';
import 'package:codingo/views/options_pages/user_follow/feature/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/views/options_pages/user_follow/feature/theme/user_list_tile_theme.dart';
import 'package:codingo/views/options_pages/user_follow/model/follow_user_model.dart';
import 'package:codingo/views/options_pages/user_follow/service/user_follow_service.dart';


class OtherFollowView extends StatefulWidget {
  const OtherFollowView({super.key});

  @override
  State<OtherFollowView> createState() => _OtherFollowViewState();
}

class _OtherFollowViewState extends State<OtherFollowView> with NavigatorMixin {
  final _currentPage = NavigatorRoutesPaths.userProfile;
  late final UserFollowService _service;
  String _username = '';
  @override
  void initState() {
    super.initState();
    _initializeValue();
    _service = UserFollowService();
  }

  void _initializeValue() {
    Future.microtask(() {
      final modelArgs = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        if (modelArgs != null && modelArgs is String) {
          _username = modelArgs;
        }
      });
    });
  }
  
  Future<List<FollowUserModel>> _fetchData() async{
    final response = await _service.getFollowList(_username);
    return response;
  }
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(
          '$_username Takipleri',
          style: const TextStyle(
            fontFamily: FontTheme.fontFamily,
            fontWeight: FontTheme.xfontWeight,
            fontSize: FontTheme.xlfontSize
          ),
        ),
        leading: IconButton(
          onPressed: () {
            router.pushReplacementToPage(NavigatorRoutesPaths.userProfile,arguments: {'username' : _username});
          },
          icon: const Icon(Icons.chevron_left_rounded,size: 32)
          ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _builder(device),
      bottomNavigationBar: CustomBottomBar(activePage: _currentPage,)
    );
  }

  FutureBuilder<List<FollowUserModel>> _builder(Size device) {
    return FutureBuilder<List<FollowUserModel>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _progress();
        } else if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        } else {
          final List<FollowUserModel>? follow = snapshot.data;
          if (follow != null && follow.isNotEmpty) {
            return ListView.builder(
              itemCount: follow.length,
              itemBuilder: (context, index) {
                final followUser = follow[index];
                return User(
                  device: device, 
                  followUser: followUser,
                  onTap: () { 
                    router.pushReplacementToPage(NavigatorRoutesPaths.userProfile,arguments: {'username' : followUser.username});
                  },
                 );
              },
            );
          } else {
            return ErrorNotFound(device: device,text: 'Takip Ettiği Kişi bulunamadı.',);
          }
        }
      },
    );
  }

  Center _progress() => const Center(child: CircularProgressIndicator(
    color: UserListTileTheme.progressClor,
  ));
}

