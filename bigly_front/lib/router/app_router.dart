
part of 'router.dart';

sealed class RouteNames {
  static const splash = '/';
  static const home = '/home';
  static const register = '/register';
  static const login = '/login';
  static const grow = '/grow';
  static const create = '/create';
  static const profile = '/profile';
  // static const myContentPlan = '/myContentPlan';
  static const discover = '/discover';
  static const newMessage = '/newMessage';
  static const newInsight = '/newInsight';
  static const videoEdit = '/videoEdit';
  static const videoView = '/videoView';
  static const contentPlan = '/contentPlan';
  static const posts = '/posts';
  static const chooseContentAdd = '/chooseContentAdd';
  static const chat = '/chat';
  static const videoRecord = '/videoRecord';
  static const createVoiceMessage = '/createVoiceMessage';
  static const createTextMessage = '/createTextMessage';
  static const createVideoMessage = '/createVideoMessage';
  static const createImageMessage = '/createImageMessage';
  static const contacts = '/contacts';
  static const addMembers = '/addMembers';
  static const addTo = '/addTo';
  static const messageRequests = '/messageRequests';
  static const myPayouts = '/myPayouts';
  static const myPayoutsData = '/myPayoutsData';
  static const createGroup = '/createGroup';
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return NavigationBar(child: child);
      },
      routes: [
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: RouteNames.grow,
          builder: (context, state) {
            return const GrowPage();
          },
        ),
        GoRoute(
          path: RouteNames.discover,
          builder: (context, state) {
            return const DiscoverPage();
          },
        ),
      ],
    ),

    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) {
        return const RegisterPage();
      },
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) {
        final profileEnum = state.extra as ProfileEnum;
        return MyProfilePage(
          profileEnum: profileEnum,
        );
      },
    ),
    // GoRoute(
    //   path: RouteNames.myContentPlan,
    //   builder: (context, state) {
    //     return const MyContentPlanPage();
    //   },
    // ),
    GoRoute(
      path: RouteNames.newMessage,
      builder: (context, state) {
        return const NewMessagePage();
      },
    ),
    GoRoute(
      path: RouteNames.newInsight,
      builder: (context, state) {
        (NewInsightEnum, File?) newInsightParam = state.extra as (NewInsightEnum, File?);
        return NewInsight(
          newInsightParam: newInsightParam,
        );
      },
    ),
    GoRoute(
      path: RouteNames.videoEdit,
      builder: (context, state) {
        final (File, double) value = state.extra as (File, double);
        return VideoEditPage(
          file: value.$1,
          aspectRatio: value.$2,
        );
      },
    ),
    GoRoute(
      path: RouteNames.videoView,
      builder: (context, state) {
        final File file = state.extra as File;
        return VideoViewPage(
          file: file,
        );
      },
    ),
    GoRoute(
      path: RouteNames.contentPlan,
      builder: (context, state) {
        final AddToEnum pageState = state.extra as AddToEnum;
        return AddTo(
          pageState: pageState,
        );
      },
    ),
    GoRoute(
      path: RouteNames.posts,
      builder: (context, state) {
        final int id = state.extra as int;
        return PostsPage(id: id,);
      },
    ),
    GoRoute(
      path: RouteNames.chooseContentAdd,
      builder: (context, state) {
        return const ChooseContentToAdd();
      },
    ),
    GoRoute(
      path: RouteNames.videoRecord,
      builder: (context, state) {
        return const VideoRecordPage();
      },
    ),
    GoRoute(
      path: RouteNames.chat,
      builder: (context, state) {
        int id = state.extra as int;
        return ChatPage(id: id,);
      },
    ),
    GoRoute(
      path: RouteNames.createTextMessage,
      builder: (context, state) {
        return const CreateTextMessagePage();
      },
    ),
    GoRoute(
      path: RouteNames.createVideoMessage,
      builder: (context, state) {
        return const CreateVideoMessagePage();
      },
    ),
    GoRoute(
      path: RouteNames.createImageMessage,
      builder: (context, state) {
        return const CreateImageMessagePage();
      },
    ),
    GoRoute(
      path: RouteNames.createVoiceMessage,
      builder: (context, state) {
        return const CreateVoiceMessagePage();
      },
    ),
    GoRoute(
      path: RouteNames.contacts,
      builder: (context, state) {
        return const NewChatPage();
      },
    ),
    GoRoute(
      path: RouteNames.addMembers,
      builder: (context, state) {
        return const AddMembersPage();
      },
    ),
    GoRoute(
      path: RouteNames.addTo,
      builder: (context, state) {
        AddToEnum? pageState = state.extra as AddToEnum;
        return AddTo(pageState: pageState);
      },
    ),
    GoRoute(
      path: RouteNames.messageRequests,
      builder: (context, state) {
        return MessageRequestsPage();
      },
    ),
    GoRoute(
      path: RouteNames.myPayouts,
      builder: (context, state) {
        return PaymentsPage();
      },
    ),
    GoRoute(
      path: RouteNames.myPayoutsData,
      builder: (context, state) {
        return PaymentsData();
      },
    ),
    GoRoute(
      path: RouteNames.createGroup,
      builder: (context, state) {
        return const CreateGroupPage();
      },
    ),

  ],
);