import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:movie_app/api/DioClient.dart';
import 'package:movie_app/bloc/netflix_bloc.dart';
import 'package:movie_app/bloc/cubit/animation_status_cubit.dart';
import 'package:movie_app/bloc/cubit/movie_details_tab_cubit.dart';
import 'package:movie_app/model/Movie.dart';
import 'package:movie_app/screens/HomeScreen.dart';
import 'package:movie_app/screens/MovieDetailsScreen.dart';
import 'package:movie_app/screens/NetflixScaffold.dart';
import 'package:movie_app/screens/NewAndHotScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/screens/AuthenticationScreen.dart';
import 'package:movie_app/screens/SplashScreen.dart';
import 'package:movie_app/screens/VerifyPhoneNumberScreen.dart';
import 'package:toast/toast.dart';
import 'api/repository.dart';
import 'screens/ProfileSelectionScreen.dart';
import 'utils/utils.dart';

main() async {
  await DioClient.init();
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  } catch (e) {
    showError(e);
  }
  runApp(NetflixApp());
}

class NetflixApp extends StatefulWidget {
  NetflixApp({super.key});

  @override
  State<NetflixApp> createState() => _NetflixAppState();
}

class _NetflixAppState extends State<NetflixApp> {
  final TMDBRepository _repository = TMDBRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileSelectorBloc>(
            create: (BuildContext context) => ProfileSelectorBloc(),
          ),
          BlocProvider<AnimationStatusCubit>(
            create: (BuildContext context) => AnimationStatusCubit(),
          ),
          BlocProvider<MovieDetailsTabCubit>(
            create: (BuildContext context) => MovieDetailsTabCubit(),
          ),
          BlocProvider<ConfigurationBloc>(
            create: (BuildContext context) =>
                ConfigurationBloc(repository: _repository)
                  ..add(FetchConfiguration()),
            lazy: false,
          ),
          BlocProvider<TrendingMovieListWeeklyBloc>(
            create: (BuildContext context) =>
                TrendingMovieListWeeklyBloc(repository: _repository),
          ),
          BlocProvider<TrendingMovieListDailyBloc>(
            create: (BuildContext context) =>
                TrendingMovieListDailyBloc(repository: _repository),
          ),
          BlocProvider<TrendingTvShowListWeeklyBloc>(
            create: (BuildContext context) =>
                TrendingTvShowListWeeklyBloc(repository: _repository),
          ),
          BlocProvider<TrendingTvShowListDailyBloc>(
            create: (BuildContext context) =>
                TrendingTvShowListDailyBloc(repository: _repository),
          ),
          BlocProvider<TvShowSeasonSelectorBloc>(
            create: (BuildContext context) =>
                TvShowSeasonSelectorBloc(repository: _repository),
          ),
          BlocProvider<DiscoverTvShowsBloc>(
            create: (BuildContext context) =>
                DiscoverTvShowsBloc(repository: _repository),
          ),
          BlocProvider<DiscoverMoviesBloc>(
            create: (BuildContext context) =>
                DiscoverMoviesBloc(repository: _repository),
          ),
        ],
        child: FirebasePhoneAuthProvider(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            title: 'Movie App',
            theme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: backgroundColor,
                appBarTheme:
                    const AppBarTheme(backgroundColor: backgroundColor)),
          ),
        ),
      ),
    );
  }

  late final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return NetflixScaffold(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/splash',
            builder: (BuildContext context, GoRouterState state) {
              return const SplashScreen();
            },
          ),
          GoRoute(
            path: '/login',
            builder: (BuildContext context, GoRouterState state) {
              return const AuthenticationScreen();
            },
          ),
          GoRoute(
            path: '/otp',
            builder: (BuildContext context, GoRouterState state) {
              return VerifyPhoneNumberScreen(
                phoneNumber: state.extra as String,
              );
            },
          ),
          GoRoute(
            path: '/profile',
            builder: (BuildContext context, GoRouterState state) {
              return const ProfileSelectionScreen();
            },
          ),
          GoRoute(
              name: 'Home',
              path: '/home',
              builder: (BuildContext context, GoRouterState state) {
                return const HomeScreen();
              },
              routes: [
                GoRoute(
                    name: 'TV Shows',
                    path: 'tvshows',
                    builder: (BuildContext context, GoRouterState state) {
                      return HomeScreen(name: state.name);
                    },
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                          key: state.pageKey,
                          child: HomeScreen(name: state.name),
                          transitionDuration: const Duration(milliseconds: 600),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final status = context.read<AnimationStatusCubit>();
                            animation.removeStatusListener(status.onStatus);
                            animation.addStatusListener(status.onStatus);
                            secondaryAnimation
                                .removeStatusListener(status.onStatus);
                            secondaryAnimation
                                .addStatusListener(status.onStatus);
                            return FadeTransition(
                                opacity: animation, child: child);
                          });
                    },
                    routes: [
                      GoRoute(
                        path: 'details',
                        builder: (BuildContext context, GoRouterState state) {
                          return MovieDetailsScreen(
                              movie: state.extra as Movie);
                        },
                      ),
                    ]),
                GoRoute(
                  path: 'details',
                  builder: (BuildContext context, GoRouterState state) {
                    return MovieDetailsScreen(movie: state.extra as Movie);
                  },
                ),
              ]),
          GoRoute(
            path: '/newandhot',
            builder: (BuildContext context, GoRouterState state) {
              return const NewAndHotScreen();
            },
            routes: [
              GoRoute(
                path: 'details',
                builder: (BuildContext context, GoRouterState state) {
                  return MovieDetailsScreen(movie: state.extra as Movie);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
