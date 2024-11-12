import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_simple_note/controllers/state_controller.dart';

import 'package:my_simple_note/data/data_providers/note.dart';
import 'package:my_simple_note/data/models/note_model.dart';
import 'package:my_simple_note/presentation/screens/note_edit_page.dart';
import 'package:my_simple_note/utils/constants/color.dart';
import 'package:my_simple_note/utils/constants/size.dart';
import 'package:my_simple_note/utils/constants/text_style.dart';
import 'package:my_simple_note/utils/constants/theme.dart';

class NotesTile extends StatefulWidget {
  final int index;
  // final double extent;
  final NoteModel noteData;
  const NotesTile({
    super.key,
    required this.index,
    // required this.extent,
    required this.noteData,
  });

  @override
  State<NotesTile> createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {
  final StateController stateController = Get.find();
  IconData pinIcon = Icons.push_pin_outlined;
  late NoteModel data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Assign data
    setState(() {
      data = widget.noteData;
    });
    setPinnedState();
  }

  void setPinnedState() {
    if (data.pinned == 1) {
      pinIcon = Icons.push_pin;
    } else {
      pinIcon = Icons.push_pin_outlined;
    }
  }

  Future<void> pinNote() async {
    if (data.pinned == 0) {
      NoteModel model = NoteModel(
        noteId: data.noteId,
        noteTitle: data.noteTitle,
        noteText: data.noteText,
        pinned: 1, //pinned 1
        createdAt: data.createdAt,
        updatedAt: data.createdAt,
      );
      int noteID = await Note().updateRecord(model: model);
      debugPrint("$noteID");
      List<NoteModel> allNotes = await Note().fetchAllRecords();
      List<NoteModel> pinnedNotes = await Note().fetchPinnedNotes();
      setState(() {
        // Setting lists
        stateController.setAllNotesList(allNotes);
        stateController.setPinnedNotesList(pinnedNotes);
      });
      NoteModel note = await Note().fetchById(noteId: data.noteId!);
      setState(() {
        data = note;
      });
    }
  }

  Future<void> unpinNote() async {
    if (data.pinned == 1) {
      NoteModel model = NoteModel(
        noteId: data.noteId,
        noteTitle: data.noteTitle,
        noteText: data.noteText,
        pinned: 0, //pinned 0
        createdAt: data.createdAt,
        updatedAt: data.createdAt,
      );
      int noteID = await Note().updateRecord(model: model);
      debugPrint("$noteID");
      List<NoteModel> allNotes = await Note().fetchAllRecords();
      List<NoteModel> pinnedNotes = await Note().fetchPinnedNotes();
      setState(() {
        // Setting lists
        stateController.setAllNotesList(allNotes);
        stateController.setPinnedNotesList(pinnedNotes);
      });
      NoteModel note = await Note().fetchById(noteId: data.noteId!);
      setState(() {
        data = note;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Nav to Edit Node
        Get.to(() => NoteEditPage(noteData: data, isUpdate: true));
      },
      child: Container(
        decoration: BoxDecoration(
            color: CFGTheme.tileBg,
            borderRadius: BorderRadius.circular(CFGSize.tileRadius),
            border: Border.all(color: CFGColor.darkGrey)),
        // Measure height dynamically
        height: data.noteText == null || data.noteText == ""
            ? 100
            : data.noteText!
                        .replaceAll(RegExp(r'[^a-zA-Z]'), '')
                        .length
                        .toDouble() >
                    200
                ? 250
                : 200,
        padding: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //Title
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    data.noteTitle ?? "",
                    style: const TextStyle(
                      // overflow: TextOverflow.ellipsis,
                      fontFamily: CFGTextStyle.clashGrotesk,
                      fontSize: CFGTextStyle.subTitleFontSize,
                      fontWeight: CFGTextStyle.mediumFontWeight,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),

                // Pin button
                SizedBox(
                  height: 25,
                  width: 25,
                  child: IconButton(
                    iconSize: 20,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        if (pinIcon == Icons.push_pin_outlined) {
                          // 1 pinned in db & re populate pinned & all lists (Use stateController to store both lists)
                          pinNote();

                          // Change to filled pin
                          pinIcon = Icons.push_pin;
                        } else {
                          // 0 pinned in db & re populate pinned & all lists (Use stateController to store both lists)
                          unpinNote();

                          // Change to outlined pin
                          pinIcon = Icons.push_pin_outlined;
                        }
                      });
                    },
                    icon: Icon(pinIcon),
                  ),
                ),
              ],
            ),
            //
            Divider(color: CFGColor.lightGrey),
            //Body
            Flexible(
              child: Text(data.noteText ?? "",
                  style: const TextStyle(
                    fontFamily: CFGTextStyle.manrope,
                    fontSize: CFGTextStyle.defaultFontSize,
                    fontWeight: CFGTextStyle.mediumFontWeight,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
