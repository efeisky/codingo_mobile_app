import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/navigator_extension.dart';
import 'package:codingo/views/control/feature/user_control.dart';
import 'package:codingo/views/forget_password/feature/reset_pass_view.dart';
import 'package:codingo/views/forget_password/feature/send_code_view.dart';
import 'package:codingo/views/forget_password/feature/verify_code_view.dart';
import 'package:codingo/views/home/view/home_page.dart';
import 'package:codingo/views/lesson/feature/lesson_check_view.dart';
import 'package:codingo/views/lesson/feature/lesson_finish_view.dart';
import 'package:codingo/views/lesson/feature/lesson_information_view.dart';
import 'package:codingo/views/lesson/feature/lesson_question_view.dart';
import 'package:codingo/views/lesson_detail/feature/lesson_detail_view.dart';
import 'package:codingo/views/login/feature/login_page.dart';
import 'package:codingo/views/options_pages/change_password/feature/change_password_view.dart';
import 'package:codingo/views/options_pages/logout/feature/logout_view.dart';
import 'package:codingo/views/menu_page/menu_view.dart';
import 'package:codingo/views/options_pages/user_follow/feature/user_follow_view.dart';
import 'package:codingo/views/options_pages/user_follow/feature/user_followers_view.dart';
import 'package:codingo/views/options_pages/user_nots/feature/user_not_detail.dart';
import 'package:codingo/views/options_pages/user_nots/feature/user_nots_view.dart';
import 'package:codingo/views/options_pages/user_order/feature/user_order.dart';
import 'package:codingo/views/options_pages/user_qr/user_qr_view.dart';
import 'package:codingo/views/options_pages/user_settings/feature/user_setting_view.dart';
import 'package:codingo/views/options_pages/verify_mail/feature/user_verify_email.dart';
import 'package:codingo/views/options_pages/verify_mail/feature/user_verify_email_code.dart';
import 'package:codingo/views/options_pages/verify_phone/feature/user_verify_phone.dart';
import 'package:codingo/views/options_pages/verify_phone/feature/user_verify_phone_code.dart';
import 'package:codingo/views/practice/feature/practice_lesson_view.dart';
import 'package:codingo/views/python_level/feature/python_level_decide.dart';
import 'package:codingo/views/python_level/feature/python_level_question.dart';
import 'package:codingo/views/register/feature/complete_register.dart';
import 'package:codingo/views/register/feature/first_register.dart';
import 'package:codingo/views/register/feature/second_register.dart';
import 'package:codingo/views/user_discover/features/scan_qr_code_view.dart';
import 'package:codingo/views/user_discover/features/user_discover_view.dart';
import 'package:codingo/views/user_home/feature/user_home_view.dart';
import 'package:codingo/views/user_message/feature/message_pages/school_chat_view.dart';
import 'package:codingo/views/user_message/feature/message_pages/user_to_user_view.dart';
import 'package:codingo/views/user_message/feature/user_message_view.dart';
import 'package:codingo/views/user_profile/feature/report_profile_view.dart';
import 'package:codingo/views/user_profile/feature/user_profile_view.dart';
import 'package:codingo/views/user_profile/feature/widget/other_follow_widget.dart';
import 'package:codingo/views/user_profile/feature/widget/other_follower_widget.dart';

class NavigatorRoutes {
  static const defaultUrl = '/';
  final items = {
    defaultUrl : (context) => const UserControl(),
    NavigatorRoutesPaths.home.withParaf : (context) => const Homepage(),
    NavigatorRoutesPaths.login.withParaf : (context) => const LoginPage(),
    NavigatorRoutesPaths.forgetPass.withParaf : (context) => const SendForgetCodeView(),
    NavigatorRoutesPaths.verifyCode.withParaf : (context) => const VerifyResetCodeView(),
    NavigatorRoutesPaths.resetPass.withParaf : (context) => const ResetPassView(),
    NavigatorRoutesPaths.register.withParaf : (context) => const FirstRegisterView(),
    NavigatorRoutesPaths.secondRegister.withParaf : (context) => const SecondRegisterView(),
    NavigatorRoutesPaths.completeRegister.withParaf : (context) => const CompleteRegisterView(),
    NavigatorRoutesPaths.userHome.withParaf : (context) => const UserHomeView(),
    NavigatorRoutesPaths.lessonCheck.withParaf : (context) => const LessonCheckView(),
    NavigatorRoutesPaths.lessonInformation.withParaf : (context) => const LessonInformationView(),
    NavigatorRoutesPaths.lessonQuestion.withParaf : (context) => const LessonQuestionView(),
    NavigatorRoutesPaths.lessonFinish.withParaf : (context) => const LessonFinishView(),
    NavigatorRoutesPaths.practice.withParaf : (context) => const PracticeView(),
    NavigatorRoutesPaths.pythonDecide.withParaf : (context) => const PythonLevelDecide(),
    NavigatorRoutesPaths.pythonLeveling.withParaf : (context) => const PythonLevelingView(),
    NavigatorRoutesPaths.lessonDetail.withParaf : (context) => const LessonDetailView(),
    NavigatorRoutesPaths.userMessage.withParaf : (context) => const UserMessageView(),
    NavigatorRoutesPaths.messageAsUser.withParaf : (context) => const UserToUserMessageView(),
    NavigatorRoutesPaths.messageAsSchool.withParaf : (context) => const ChatSchoolView(),
    NavigatorRoutesPaths.userDiscover.withParaf : (context) => const UserDiscoverView(),
    NavigatorRoutesPaths.scanQrCode.withParaf : (context) => const QrCodeScannerView(),
    NavigatorRoutesPaths.userProfile.withParaf : (context) => const UserProfileView(),
    NavigatorRoutesPaths.menu.withParaf : (context) => const MenuView(),
    NavigatorRoutesPaths.userSettings.withParaf : (context) => const UserSettingView(),
    NavigatorRoutesPaths.userNots.withParaf : (context) => const UserNotsView(),
    NavigatorRoutesPaths.userNotDetail.withParaf : (context) => const UserNotContentDetail(),
    NavigatorRoutesPaths.userOrder.withParaf : (context) => const UserOrderView(),
    NavigatorRoutesPaths.userQr.withParaf : (context) => const UserQrView(),
    NavigatorRoutesPaths.userFollowers.withParaf : (context) => const UserFollowersView(),
    NavigatorRoutesPaths.otherFollowers.withParaf : (context) => const OtherFollowerView(),
    NavigatorRoutesPaths.userFollow.withParaf : (context) => const UserFollowView(),
    NavigatorRoutesPaths.otherFollow.withParaf : (context) => const OtherFollowView(),
    NavigatorRoutesPaths.reportProfile.withParaf : (context) => const ReportProfileView(),
    NavigatorRoutesPaths.changePassword.withParaf : (context) => const ChangePasswordView(),
    NavigatorRoutesPaths.verifyEmail.withParaf : (context) => const UserVerifyEmail(),
    NavigatorRoutesPaths.verifyEmailCode.withParaf : (context) => const UserVerifyEmailCode(),
    NavigatorRoutesPaths.verifyPhone.withParaf : (context) => const UserVerifyPhone(),
    NavigatorRoutesPaths.verifyPhoneCode.withParaf : (context) => const UserVerifyPhoneCode(),
    NavigatorRoutesPaths.logOut.withParaf : (context) => const LogOutView(),
  };
}

