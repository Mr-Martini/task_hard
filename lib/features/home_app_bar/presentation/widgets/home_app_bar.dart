import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:task_hard/components/color-selector-component/color-selector-component.dart';
import 'package:task_hard/core/Utils/home_selected_notes.dart';
import 'package:task_hard/core/widgets/profile_icon_button.dart';
import 'package:task_hard/features/home_app_bar/presentation/bloc/homeappbar_bloc.dart';
import 'package:task_hard/features/note/domain/entities/note.dart';
import 'package:task_hard/generated/l10n.dart';

enum HomeAppBarPoUpMenuOption { change_color }

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  HomeAppBar({Key key}) : super(key: key);

  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(55);
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  AnimationController leadingAnimation;

  @override
  void initState() {
    leadingAnimation = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    leadingAnimation.dispose();
    super.dispose();
  }

  void showColorChooser() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext _) {
        return ColorSelector(
          onTap: (Color color) {
            Navigator.pop(context);
            HomeSelectedNotes provider =
                Provider.of<HomeSelectedNotes>(context, listen: false);
            List<Note> selectedNotes = List<Note>.from(provider.getNotes);
            BlocProvider.of<HomeappbarBloc>(context)
              ..add(ChangeColor(
                selectedNotes: selectedNotes,
                color: color,
              ))
              ..add(AddNote(selectedNotes: <Note>[]));
            provider.clear();
          },
        );
      },
    );
  }

  void onSelected(HomeAppBarPoUpMenuOption option) {
    switch (option) {
      case HomeAppBarPoUpMenuOption.change_color:
        showColorChooser();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    S translate = S.of(context);

    return BlocBuilder<HomeappbarBloc, HomeappbarState>(
      builder: (context, state) {
        if (state is HomeappbarInitial) {
          return AppBar(
            iconTheme: IconThemeData(
              color: Theme.of(context).iconTheme.color,
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              translate.app_name,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline6.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              ProfileIconButton(),
            ],
          );
        } else if (state is Loaded) {
          var notes = state.selectedNotes.selectedNotes;
          if (notes.length >= 1) {
            leadingAnimation.forward();
            return AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: leadingAnimation,
                ),
                onPressed: () {
                  BlocProvider.of<HomeappbarBloc>(context).add(
                    AddNote(
                      selectedNotes: <Note>[],
                    ),
                  );
                  Provider.of<HomeSelectedNotes>(context, listen: false)
                      .clear();
                },
              ),
              title: Text(notes.length.toString()),
              actions: [
                IconButton(
                  icon: Icon(Icons.add_alert),
                  onPressed: () {},
                ),
                PopupMenuButton<HomeAppBarPoUpMenuOption>(
                  onSelected: onSelected,
                  itemBuilder: (context) =>
                      <PopupMenuEntry<HomeAppBarPoUpMenuOption>>[
                    PopupMenuItem<HomeAppBarPoUpMenuOption>(
                      value: HomeAppBarPoUpMenuOption.change_color,
                      child: ListTile(
                        leading: Icon(Icons.palette),
                        title: Text(translate.change_color),
                        subtitle: Divider(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          leadingAnimation.reverse();
          return AppBar(
            iconTheme: IconThemeData(
              color: Theme.of(context).iconTheme.color,
            ),
            leading: IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: leadingAnimation,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              translate.app_name,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline6.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              ProfileIconButton(),
            ],
          );
        }
        return Container();
      },
    );
  }
}