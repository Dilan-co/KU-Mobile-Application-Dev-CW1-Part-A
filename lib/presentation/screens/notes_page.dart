import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:my_simple_note/controllers/state_controller.dart';
import 'package:my_simple_note/data/data_providers/note.dart';
import 'package:my_simple_note/data/models/note_model.dart';
import 'package:my_simple_note/presentation/widgets/notes_tile.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final StateController stateController = Get.find();
  late Future<bool> loadingFuture;
  List<NoteModel> allList = [];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   setState(() {
  //     loadingFuture = setList();
  //   });
  // }

  // Future<bool> setList() async {
  //   List<NoteModel> list = await stateController.getAllNotesList();
  //   setState(() {
  //     allList = list;
  //   });
  //   return true;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateNoteLists();
    debugPrint("Notes View");
  }

  Future<void> generateNoteLists() async {
    List<NoteModel> allNotes = await Note().fetchAllRecords();
    List<NoteModel> pinnedNotes = await Note().fetchPinnedNotes();
    setState(() {
      // Setting lists
      stateController.setAllNotesList(allNotes);
      stateController.setPinnedNotesList(pinnedNotes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // Get the updated list of notes from the controller
        List<NoteModel> allList = stateController.getAllNotesList();

        return MasonryGridView.count(
          itemCount: allList.length,
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            return NotesTile(
              index: index,
              noteData: allList[index],
            );
          },
        );
      },
    );
  }
}
