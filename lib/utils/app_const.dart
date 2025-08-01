import 'package:ridebooking/models/bus_data.dart';

class AppConst {

  static  BusData busdata = BusData.fromJson({
    "totalRows": 8,
    "totalColumns": 5,
    "seats": [
      // Lower Deck
      {
        "seatNumber": "L1",
        "row": 0,
        "column": 0,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L2",
        "row": 0,
        "column": 1,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L3",
        "row": 0,
        "column": 3,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L4",
        "row": 0,
        "column": 4,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      {
        "seatNumber": "L5",
        "row": 1,
        "column": 0,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L6",
        "row": 1,
        "column": 1,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L7",
        "row": 1,
        "column": 3,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L8",
        "row": 1,
        "column": 4,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      {
        "seatNumber": "L9",
        "row": 2,
        "column": 0,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L10",
        "row": 2,
        "column": 1,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L11",
        "row": 2,
        "column": 3,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L12",
        "row": 2,
        "column": 4,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      {
        "seatNumber": "L13",
        "row": 3,
        "column": 0,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L14",
        "row": 3,
        "column": 1,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L15",
        "row": 3,
        "column": 3,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L16",
        "row": 3,
        "column": 4,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      {
        "seatNumber": "L17",
        "row": 4,
        "column": 0,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L18",
        "row": 4,
        "column": 1,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L19",
        "row": 4,
        "column": 3,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },
      {
        "seatNumber": "L20",
        "row": 4,
        "column": 4,
        "status": "available",
        "fare": 1050,
        "berth": "lower",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": false,
        "tax": 50
      },

      // Upper Deck
      {
        "seatNumber": "U1",
        "row": 0,
        "column": 0,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U2",
        "row": 0,
        "column": 1,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U3",
        "row": 0,
        "column": 3,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U4",
        "row": 0,
        "column": 4,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },

      {
        "seatNumber": "U5",
        "row": 1,
        "column": 0,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U6",
        "row": 1,
        "column": 1,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U7",
        "row": 1,
        "column": 3,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U8",
        "row": 1,
        "column": 4,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },

      {
        "seatNumber": "U9",
        "row": 2,
        "column": 0,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U10",
        "row": 2,
        "column": 1,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U11",
        "row": 2,
        "column": 3,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U12",
        "row": 2,
        "column": 4,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "male",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },

      {
        "seatNumber": "U13",
        "row": 3,
        "column": 0,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U14",
        "row": 3,
        "column": 1,
        "status": "available",
        "fare": 1050,
        "berth": "upper",
        "gender": "female",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U15",
        "row": 3,
        "column": 3,
        "status": "available",
        "fare": int.parse(int.parse(1050.toString()).toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      },
      {
        "seatNumber": "U16",
        "row": 3,
        "column": 4,
        "status": "available",
        "fare": int.parse(1050.toString()),
        "berth": "upper",
        "gender": "any",
        "seatType": "sleeper",
        "isAC": true,
        "tax": 70
      }
    ]
  });
}