class CardModel {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final CardType type;

  CardModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.type,
  });
}

enum CardType {
  mastercard,
  visa,
  paypal, 
  other, 
}


// class CardModel {
//   final String cardNumber;
//   final String expiryDate;
//   final String cvv;
//   final CardType type;

//   CardModel({
//     required this.cardNumber,
//     required this.expiryDate,
//     required this.cvv,
//     required this.type,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'cardNumber': cardNumber,
//       'expiryDate': expiryDate,
//       'cvv': cvv,
//       'type': type.toString(),
//     };
//   }

//   factory CardModel.fromJson(Map<String, dynamic> json) {
//     return CardModel(
//       cardNumber: json['cardNumber'],
//       expiryDate: json['expiryDate'],
//       cvv: json['cvv'],
//       type: _cardTypeFromString(json['type']),
//     );
//   }

//   static CardType _cardTypeFromString(String typeString) {
//     switch (typeString) {
//       case 'CardType.mastercard':
//         return CardType.mastercard;
//       case 'CardType.visa':
//         return CardType.visa;
//       case 'CardType.paypal':
//         return CardType.paypal;
//       default:
//         return CardType.unknown;
//     }
//   }
// }

// enum CardType { mastercard, visa, paypal, unknown }
