import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_simple_note/utils/constants/theme.dart';

class NotesDrawer extends StatefulWidget {
  final Function(bool) onSave;
  final Function(bool) onDelete;
  final bool isUpdate;
  const NotesDrawer({
    super.key,
    required this.onSave,
    required this.onDelete,
    required this.isUpdate,
  });

  @override
  State<NotesDrawer> createState() => _NotesDrawerState();
}

class _NotesDrawerState extends State<NotesDrawer> {
  bool isTappedSave = false;
  bool isTappedClose = false;
  bool isTappedDelete = false;

  // Toggle the icon state
  void toggleIconSave() {
    setState(() {
      isTappedSave = !isTappedSave;
    });
    if (isTappedSave) {
      Future.delayed(const Duration(milliseconds: 300), () {
        //Trigger save function
        widget.onSave(true);
        //Return
        Get.close(2);
      });
    }
  }

  void toggleIconDelete() {
    setState(() {
      isTappedDelete = !isTappedDelete;
    });
    if (isTappedDelete) {
      Future.delayed(const Duration(milliseconds: 300), () {
        //Trigger delete function
        widget.onDelete(true);
        //Return
        Get.close(2);
      });
    }
  }

  void toggleIconClose() {
    setState(() {
      isTappedClose = !isTappedClose;
    });
    if (isTappedClose) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.close(2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 250, bottom: 250),
      child: Drawer(
        elevation: 5,
        shadowColor: CFGTheme.buttonLightGrey,
        surfaceTintColor: CFGTheme.bgColorScreen,
        backgroundColor: CFGTheme.bgColorScreen,
        width: mediaQuerySize.width * 0.16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              const Spacer(),

              //Save
              Center(
                child: IconButton(
                  onPressed: toggleIconSave,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300), // Set duration
                    transitionBuilder: (child, animation) {
                      // Define the transition (Rotation and Fade)
                      return RotationTransition(
                        turns: Tween<double>(begin: 0.9, end: 1)
                            .animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      size: 32,
                      isTappedSave ? Icons.check : Icons.save_as_outlined,
                      key: ValueKey(isTappedSave ? 'close' : 'save'),
                    ),
                  ),
                ),
              ),

              //
              const Spacer(),

              //Delete
              widget.isUpdate
                  ? Center(
                      child: IconButton(
                        onPressed: toggleIconDelete,
                        icon: AnimatedSwitcher(
                          duration:
                              const Duration(milliseconds: 300), // Set duration
                          transitionBuilder: (child, animation) {
                            // Define the transition (Rotation and Fade)
                            return RotationTransition(
                              turns: Tween<double>(begin: 0.9, end: 1)
                                  .animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Icon(
                            size: 32,
                            isTappedDelete
                                ? Icons.check
                                : Icons.delete_forever_outlined,
                            key: ValueKey(isTappedDelete ? 'exit' : 'delete'),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),

              //
              const Spacer(),

              //Close
              Center(
                child: IconButton(
                  onPressed: toggleIconClose,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300), // Set duration
                    transitionBuilder: (child, animation) {
                      // Define the transition (Rotation and Fade)
                      return RotationTransition(
                        turns: Tween<double>(begin: 0.9, end: 1)
                            .animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      size: 32,
                      isTappedClose ? Icons.check : Icons.cancel_outlined,
                      key: ValueKey(isTappedClose ? 'exit' : 'close'),
                    ),
                  ),
                ),
              ),

              //
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
