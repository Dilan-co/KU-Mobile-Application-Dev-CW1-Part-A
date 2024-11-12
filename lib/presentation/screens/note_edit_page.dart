import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_simple_note/controllers/state_controller.dart';
import 'package:my_simple_note/data/data_providers/note.dart';
import 'package:my_simple_note/data/models/note_model.dart';
import 'package:my_simple_note/presentation/widgets/notes_drawer.dart';
import 'package:my_simple_note/utils/constants/color.dart';
import 'package:my_simple_note/utils/constants/size.dart';
import 'package:my_simple_note/utils/constants/text_style.dart';
import 'package:my_simple_note/utils/constants/theme.dart';

class NoteEditPage extends StatefulWidget {
  final NoteModel? noteData;
  final bool isUpdate;
  const NoteEditPage({
    super.key,
    required this.noteData,
    required this.isUpdate,
  });

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  final StateController stateController = Get.find();
  TextEditingController textControllerTitle = TextEditingController();
  TextEditingController textControllerNote = TextEditingController();

  bool isDrawerOpen = false;
  NoteModel? data;
  String? noteTitle;
  String? noteText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Assign data
    setState(() {
      if (widget.noteData != null) {
        data = widget.noteData!;
      }
    });
    //Set Controller values
    loadInitialValues();
  }

  loadInitialValues() {
    if (widget.isUpdate) {
      setState(() {
        textControllerTitle.text = data?.noteTitle ?? "";
        textControllerNote.text = data?.noteText ?? "";
        noteTitle = data?.noteText;
        noteText = data?.noteText;
      });
    } else {
      setState(() {
        textControllerTitle.text = "";
        textControllerNote.text = "";
        noteTitle = null;
        noteText = null;
      });
    }
    debugPrint("${data?.noteTitle}");
    debugPrint("${data?.noteText}");
  }

  // Icon Animation
  void toggleDrawer(BuildContext context) {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
    if (isDrawerOpen) {
      Scaffold.of(context).openEndDrawer();
    } else {
      // Close the drawer if it's open
      Navigator.of(context).pop();
    }
  }

  Future<void> onSave(bool isPressed) async {
    DateTime now = DateTime.now();
    String createdAt =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    if (isPressed) {
      //Save note
      NoteModel model = NoteModel(
        noteId: data?.noteId,
        noteTitle: noteTitle,
        noteText: noteText,
        pinned: widget.isUpdate ? data!.pinned : 0,
        createdAt: widget.isUpdate ? data?.createdAt : createdAt,
        updatedAt: widget.isUpdate ? createdAt : null,
      );
      if (widget.isUpdate) {
        int noteID = await Note().updateRecord(model: model);
        debugPrint("$noteID");
      } else {
        int noteID = await Note().createRecord(model: model);
        debugPrint("$noteID");
      }
    }
  }

  Future<void> onDelete(bool isPressed) async {
    if (isPressed) {
      //Delete note
      Note().deleteRecord(model: widget.noteData!);
      List<NoteModel> allNotes = await Note().fetchAllRecords();
      List<NoteModel> pinnedNotes = await Note().fetchPinnedNotes();
      setState(() {
        // Setting lists
        stateController.setAllNotesList(allNotes);
        stateController.setPinnedNotesList(pinnedNotes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CFGTheme.bgColorScreen,
        drawerScrimColor: Colors.transparent,
        endDrawer: NotesDrawer(
          onSave: onSave,
          onDelete: onDelete,
          isUpdate: widget.noteData != null ? true : false,
        ),
        onEndDrawerChanged: (isOpen) {
          // Update the state when the drawer is closed
          setState(() {
            isDrawerOpen = isOpen;
          });
        },
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                //Title
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 5,
                      right: 5,
                    ),
                    child: TextFormField(
                      //
                      enabled: true,
                      controller: textControllerTitle,
                      textCapitalization: TextCapitalization.sentences,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: CFGTextStyle.titleFontSize,
                        fontWeight: CFGTextStyle.regularFontWeight,
                        color: CFGTextStyle.defaultFontColor,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                          bottom: 10,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(CFGSize.tileRadius),
                          borderSide:
                              BorderSide(color: CFGTheme.button, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(CFGSize.tileRadius),
                          borderSide: BorderSide(
                            color: CFGColor.midGrey,
                            width: 1.0,
                          ),
                        ),
                        fillColor: CFGTheme.bgColorScreen,
                        filled: true,
                        hintText: "Title",
                        hintStyle: TextStyle(
                          letterSpacing: 1,
                          fontSize: CFGTextStyle.titleFontSize,
                          fontWeight: CFGTextStyle.regularFontWeight,
                          color: CFGTextStyle.lightGreyFontColor,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(CFGSize.tileRadius)),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          noteTitle = value;
                        });
                        debugPrint(value);
                      },
                    ),
                  ),
                ),

                //Drawer Icon
                Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: () => toggleDrawer(context),
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return RotationTransition(
                            turns: child.key == ValueKey('menu')
                                ? Tween<double>(begin: 0.75, end: 1)
                                    .animate(animation)
                                : Tween<double>(begin: 1.25, end: 1)
                                    .animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          size: 32,
                          isDrawerOpen ? Icons.close : Icons.widgets_outlined,
                          key: ValueKey(isDrawerOpen ? 'close' : 'menu'),
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
            //
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  left: 5,
                  right: 5,
                ),
                child: TextFormField(
                  //
                  maxLines: null,
                  expands: true,
                  enabled: true,
                  controller: textControllerNote,
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.sentences,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: CFGTextStyle.defaultFontSize,
                    fontWeight: CFGTextStyle.regularFontWeight,
                    color: CFGTextStyle.defaultFontColor,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(CFGSize.tileRadius),
                      borderSide:
                          BorderSide(color: CFGTheme.button, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(CFGSize.tileRadius),
                      borderSide: BorderSide(
                        color: CFGColor.midGrey,
                        width: 1.0,
                      ),
                    ),
                    fillColor: CFGTheme.bgColorScreen,
                    filled: true,
                    hintText: "Type your note here",
                    hintStyle: TextStyle(
                      letterSpacing: 1,
                      fontSize: CFGTextStyle.defaultFontSize,
                      fontWeight: CFGTextStyle.regularFontWeight,
                      color: CFGTextStyle.lightGreyFontColor,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(CFGSize.tileRadius)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      noteText = value;
                    });
                    debugPrint(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
