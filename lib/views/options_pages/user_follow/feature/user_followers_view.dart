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


class UserFollowersView extends StatefulWidget {
  const UserFollowersView({super.key});

  @override
  State<UserFollowersView> createState() => _UserFollowersViewState();
}

class _UserFollowersViewState extends State<UserFollowersView> with NavigatorMixin {
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
    final response = await _service.getFollowersList(_initialUsername);
    return response;
  }
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: 'Takipçilerim',
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
          final List<FollowUserModel>? followers = snapshot.data;
          if (followers != null && followers.isNotEmpty) {
            return ListView.builder(
              itemCount: followers.length,
              itemBuilder: (context, index) {
                final followUser = followers[index];
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
            return ErrorNotFound(device: device,text: 'Takipçi bulunamadı.',);
          }
        }
      },
    );
  }

  Center _progress() => const Center(child: CircularProgressIndicator(
    color: UserListTileTheme.progressClor,
  ));
}