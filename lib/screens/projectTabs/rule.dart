import 'package:flutter/material.dart';

class Rules extends StatefulWidget {
  Rules({Key? key}) : super(key: key);

  @override
  _RulesState createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        child: ListTile(
          title: Text(
            "General Guidelines :",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
                '''Every room, habited by people, should open into an exterior or interior open space or verandah.

Open spaces should be counted in the FAR, as per the master plan.                

These areas should be free of erections of any kind, except cornice, chajja or weather shade that is not more than 0.75 metres wide.

Every interior or exterior or air space should be maintained for the benefit of such building exclusively and shall be entirely within the owner’s own premises.

The main staircase and fire escape staircase must be continuous from ground floor to the terrace level.

No electrical shafts or AC ducts and gas pipelines can run through the staircase.

Beams and columns should not reduce the headroom or width of the staircase.

For group housing, where the floor area does not exceed 300 sq metres and the height of the building is not over 24 metres, a single staircase may be acceptable. In buildings that are identified in Bye-Laws No 1.13 VI (a) to (m), a minimum of two staircases are compulsory.

Exits are compulsory and these should be clearly visible to all and must be illuminated. These cannot be reduced in number, width or by any other means. The requisite number is dependent on occupancy load, capacity, travel distance, etc.

Garages should not block access to the building in any way. It should be behind the building line of the street or road. In case it is not, the authority may even discontinue its use as a garage or suggest other alterations.'''),
          ),
        ),
      ),
    );
  }
}
