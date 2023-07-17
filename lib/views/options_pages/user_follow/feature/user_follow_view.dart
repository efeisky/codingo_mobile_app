import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/views/options_pages/user_follow/feature/error_not_found.dart';
import 'package:codingo/views/options_pages/user_follow/feature/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/views/options_pages/user_follow/feature/theme/user_list_tile_theme.dart';
import 'package:codingo/views/options_pages/user_follow/model/follow_user_model.dart';
import 'package:codingo/views/options_pages/user_follow/service/user_follow_service.dart';


class UserFollowView extends StatefulWidget {
  const UserFollowView({super.key});

  @override
  State<UserFollowView> createState() => _UserFollowViewState();
}

class _UserFollowViewState extends State<UserFollowView> with NavigatorMixin {
  final _currentPage = NavigatorRoutesPaths.userProfile;
  late final UserFollowService _service;
  String _initialUsername = '';
  @override
  void initState() {
    super.initState();
    _service = UserFollowService();
    _initialUsername = context.read<UserNotifier>().currentUsername;
  }

  Future<List<FollowUserModel>> _fetchData() async{
    final response = await _service.getFollowList(_initialUsername);
    return response;
  }
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: 'Takip Ettiklerim',
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
            return ErrorNotFound(device: device,text: 'Takip Ettiğin Kişi bulunamadı.',);
          }
        }
      },
    );
  }

  Center _progress() => const Center(child: CircularProgressIndicator(
    color: UserListTileTheme.progressClor,
  ));
}

