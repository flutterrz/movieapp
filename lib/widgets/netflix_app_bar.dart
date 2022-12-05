import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/api/globals.dart';
import 'package:movie_app/bloc/netflix_bloc.dart';
import 'package:movie_app/bloc/cubit/animation_status_cubit.dart';
import 'package:movie_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'profile_icon.dart';

class NetflixHeader extends SliverPersistentHeaderDelegate {
  final double scrollOffset;
  final String? name;
  final Duration _duration = const Duration(milliseconds: 150);

  NetflixHeader({required this.scrollOffset, this.name});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final status = context.watch<AnimationStatusCubit>();
    final opacity = status.state == AnimationStatus.forward ? 0.0 : 1.0;
    final backButtonOpacity =
        status.state != AnimationStatus.reverse ? 1.0 : 0.0;
    final canPop = GoRouter.of(context).canPop();
    return Container(
      color: Colors.black
          .withOpacity((scrollOffset / 350).clamp(0, .8).toDouble()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          canPop
              ? Row(
                  children: [
                    AnimatedOpacity(
                      duration: _duration,
                      opacity: backButtonOpacity,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(LucideIcons.arrowLeft)),
                    ),
                    Text(
                      name ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ],
                )
              : AnimatedOpacity(
                  duration: _duration,
                  opacity: opacity,
                  child: Image.asset(
                    'assets/netflix_symbol.png',
                  ),
                ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(LucideIcons.cast)),
              IconButton(
                  onPressed: () async {
                    await Globals.auth.signOut();
                    context.go('/login');
                  },
                  icon: const Icon(LucideIcons.logOut)),
              IconButton(
                onPressed: () => context.go('/profile'),
                icon: Builder(builder: (context) {
                  final state = context.read<ProfileSelectorBloc>().state;
                  return ProfileIcon(
                    color: profileColors[state.profile],
                    iconSize: IconTheme.of(context).size,
                  );
                }),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 64.0;

  @override
  double get minExtent => 64.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class NetflixBottomHeader extends SliverPersistentHeaderDelegate {
  final double scrollOffset;

  NetflixBottomHeader({required this.scrollOffset});

  final Duration _duration = const Duration(milliseconds: 150);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BlocBuilder<AnimationStatusCubit, AnimationStatus?>(
      buildWhen: ((previous, current) {
        return previous != current;
      }),
      builder: (context, status) {
        final location = GoRouter.of(context).location;
        final isTvShowsPage = location == '/home/tvshows';
        final opacity = isTvShowsPage
            ? (status == AnimationStatus.completed ? 1.0 : 0.0)
            : (status == AnimationStatus.forward ? 0.0 : 1.0);

        return Container(
          color: Colors.black
              .withOpacity((scrollOffset / 350).clamp(0, .8).toDouble()),
          child: Row(
            mainAxisAlignment: isTvShowsPage
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                tag: 'tvshows2',
                child: FittedBox(
                  child: TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: () {
                      context.goNamed('TV Shows');
                    },
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'TV Shows',
                            style: isTvShowsPage
                                ? const TextStyle(fontSize: 22.0)
                                : const TextStyle(fontSize: 18.0),
                          ),
                          if (isTvShowsPage) ...[
                            const SizedBox(
                              width: 8.0,
                            ),
                            AnimatedOpacity(
                              duration: _duration,
                              opacity: opacity,
                              child: const Icon(
                                LucideIcons.chevronDown,
                                size: 16.0,
                              ),
                            )
                          ]
                        ]),
                  ),
                ),
              ),
              if (!isTvShowsPage)
                Opacity(
                  opacity: opacity,
                  child: TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () {},
                      child: const Text(
                        'Movies',
                        style: TextStyle(fontSize: 18.0),
                      )),
                ),
              Opacity(
                opacity: opacity,
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () {},
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${isTvShowsPage && opacity == 1.0 ? 'All ' : ''}Categories',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Icon(
                          LucideIcons.chevronDown,
                          size: 16.0,
                        )
                      ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class NetflixBottomHeaderTVShows extends SliverPersistentHeaderDelegate {
  final double scrollOffset;

  NetflixBottomHeaderTVShows({required this.scrollOffset});

  final Duration _duration = const Duration(milliseconds: 150);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final status = context.watch<AnimationStatusCubit>();
    final opacity = status.state == AnimationStatus.completed ? 1.0 : 0.0;
    return Container(
      color: Colors.black
          .withOpacity((scrollOffset / 350).clamp(0, .8).toDouble()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Hero(
            tag: 'tvshows2',
            child: FittedBox(
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () {
                  context.go('/tvshows');
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'TV Shows',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      AnimatedOpacity(
                        duration: _duration,
                        opacity: opacity,
                        child: const Icon(
                          LucideIcons.chevronDown,
                          size: 14.0,
                        ),
                      )
                    ]),
              ),
            ),
          ),
          AnimatedOpacity(
            duration: _duration,
            opacity: opacity,
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {
                context.go('/tvshows');
              },
              child: Row(children: const [
                Text('All Categories'),
                SizedBox(
                  width: 8.0,
                ),
                Icon(
                  LucideIcons.chevronDown,
                  size: 18.0,
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
