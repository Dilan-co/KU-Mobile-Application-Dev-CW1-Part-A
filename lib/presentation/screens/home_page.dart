import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_simple_note/presentation/screens/note_edit_page.dart';

import 'package:my_simple_note/presentation/screens/notes_page.dart';
import 'package:my_simple_note/presentation/screens/pinned_page.dart';
import 'package:my_simple_note/utils/constants/size.dart';
import 'package:my_simple_note/utils/constants/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CFGTheme.bgColorScreen,
        body: Stack(
          children: [
            DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      toolbarHeight: 0,
                      floating: true,
                      snap: true,
                      bottom: TabBar(
                        tabs: const [
                          Tab(text: "        Notes        "),
                          Tab(text: "        Pinned        "),
                        ],
                        labelColor: CFGTheme.button,
                        unselectedLabelColor: CFGTheme.buttonOverlay,
                        textScaler: const TextScaler.linear(1.1),
                        isScrollable: false,
                        indicatorColor: CFGTheme.button,
                        indicatorWeight: 4,
                      ),
                    )
                  ];
                },
                body: const TabBarView(children: [
                  //1
                  NotesPage(),
                  //2
                  PinnedPage(),
                ]),
              ),
            ),

            // Floating Action Button
            Positioned(
              bottom: 12,
              right: 12,
              child: FloatingActionButton(
                // elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CFGSize.tileRadius),
                ),
                backgroundColor: CFGTheme.bgColorScreen.withOpacity(0.9),
                onPressed: () {
                  Get.to(() =>
                      const NoteEditPage(noteData: null, isUpdate: false));
                  // Action for the FAB
                  debugPrint('FAB clicked');
                },
                child: const Icon(
                  Icons.note_add_outlined,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
