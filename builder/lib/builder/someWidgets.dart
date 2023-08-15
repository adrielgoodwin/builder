import 'package:flutter/material.dart';
// import 'texts.dart';

import 'package:flutter/material.dart';



// TextStyle tinyText = GoogleFonts.openSans(fontSize: 19);
// TextStyle smallText = GoogleFonts.openSans(fontSize: 22);
// TextStyle medText = GoogleFonts.openSans(fontSize: 30);
// TextStyle bigText = GoogleFonts.openSans(fontSize: 36);

// TextStyle tinyText = GoogleFonts.raleway(fontSize: 19);
// TextStyle smallText = GoogleFonts.raleway(fontSize: 22);
// TextStyle medText = GoogleFonts.raleway(fontSize: 30);
// TextStyle bigText = GoogleFonts.raleway(fontSize: 36);
TextStyle tinyText = const TextStyle(fontSize: 19, color: Colors.white);
TextStyle smallText = const TextStyle(fontSize: 22, color: Colors.white);
TextStyle medText = const TextStyle(fontSize: 30, color: Colors.white);
TextStyle bigText = const TextStyle(fontSize: 36, color: Colors.white);

double medTextSize = 30;

class TinyText extends StatelessWidget {
  const TinyText(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: tinyText,);
  }
}


class SmallText extends StatelessWidget {
  const SmallText(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: smallText,);
  }
}

class MedText extends StatelessWidget {
  const MedText(this.text, {this.color = Colors.black, Key? key}) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: medText, overflow: TextOverflow.clip,);
  }
}

class BigText extends StatelessWidget {
  const BigText(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: bigText);
  }
}

class SmallTextButton extends StatelessWidget {
  const SmallTextButton(this.text, this.onTap, {Key? key}) : super(key: key);

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap,
        child: Text(text, style: smallText,),
      ),
    );
  }
}

class MedTextButton extends StatelessWidget {
  const MedTextButton(this.text, this.onTap, {this.color = Colors.black, Key? key}) : super(key: key);

  final String text;
  final Function onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Text(text, style: TextStyle(fontSize: medTextSize, color: color),),
      ),
    );
  }
}

class BigTextButton extends StatelessWidget {
  const BigTextButton(this.text, this.onTap, {Key? key}) : super(key: key);

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onTap(),
          child: Text(text, style: bigText,),
        ),
      ),
    );
  }
}

class CheckListItemData {
  String id;
  final String text;
  bool done;

  CheckListItemData(this.text, this.done, this.id);
}

// class CheckListData {
//   final String name;
//   bool complete;
//   final Map<String, CheckListItemData> items;
//   CheckListData(this.name, this.items, this.complete);
// }
//
// class CheckList extends StatelessWidget {
//   const CheckList(this.checkListData, this.dataReturn, {Key? key}) : super(key: key);
//
//   final CheckListData checkListData;
//   final Function dataReturn;
//
//   bool checkForComplete() {
//     for(var item in checkListData.items.values) {
//       if(!item.done) return false;
//     }
//     return true;
//   }
//
//   void checklistUpdate(String id, bool done) {
//     checkListData.items.update(id, (value) => CheckListItemData(value.text, done, id));
//     checkListData.complete = checkForComplete();
//     dataReturn(checkListData);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         checkListData.complete ? BigText("${checkListData.name} Complete!") :BigText("${checkListData.name} in Progress"),
//         ...checkListData.items.values.map((e) => CheckListItem(e, checklistUpdate)).toList(),
//       ],
//     );
//   }
// }


class CheckListItem extends StatefulWidget {
  const CheckListItem(this.text, this.onClick,  {Key? key}) : super(key: key);

  final String text;
  final Function onClick;

  @override
  State<CheckListItem> createState() => _CheckListItemState();
}

class _CheckListItemState extends State<CheckListItem> {

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          checked = !checked;
          widget.onClick(checked);
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            CheckBox(checked),
            Text(widget.text, style: TextStyle(color: checked ? Colors.green : Colors.black),),
          ],
        ),
      ),
    );
  }
}


class CheckBox extends StatelessWidget {
  const CheckBox(this.done, {this.x = 15, this.y = 15, this.color = Colors.green, Key? key}) : super(key: key);

  final bool done;
  final double x;
  final double y;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: x,
        height: y,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: done ? color : Colors.white,
        ),
      ),
    );
  }
}