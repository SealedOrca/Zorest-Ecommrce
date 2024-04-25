
// import 'package:fam1/Screens/Cartsection/card_model.dart';
// import 'package:flutter/material.dart';

// class PaymentPage extends StatefulWidget {
//   final TextEditingController cardNumberController;
//   final TextEditingController expiryDateController;
//   final TextEditingController cvvController;

//   const PaymentPage({super.key, 
//     required this.cardNumberController,
//     required this.expiryDateController,
//     required this.cvvController,
//   });

//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   // List to store previous cards
//   List<CardModel> previousCards = [
//     CardModel(
//       cardNumber: '2134 5688 9024 3456',
//       expiryDate: '12/24',
//       cvv: '123',
//       type: CardType.mastercard,
//     ),
//     CardModel(
//       cardNumber: '9876 5432 1098 7654',
//       expiryDate: '11/23',
//       cvv: '456',
//       type: CardType.visa,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             'Select Payment Method',
//             style: TextStyle(
//               fontSize: 20.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20.0),
//         SizedBox(
//           height: 150, // Adjust the height according to your design
//           child: ListView.separated(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             scrollDirection: Axis.horizontal,
//             itemCount: previousCards.length,
//             itemBuilder: (context, index) {
//               final card = previousCards[index];
//               return InkWell(
//                 onTap: () {
//                   // Set selected card details in the form fields
//                   widget.cardNumberController.text = card.cardNumber;
//                   widget.expiryDateController.text = card.expiryDate;
//                   widget.cvvController.text = card.cvv;
//                 },
//                 child: Container(
//                   width: 120, // Adjust the width according to your design
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     border: Border.all(
//                       color: Colors.grey[300]!,
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildCardImage(card.type),
//                       Text(
//                         'Card ending in ${card.cardNumber.substring(card.cardNumber.length - 4)}',
//                         style: const TextStyle(fontSize: 12.0),
//                       ),
//                       Text(
//                         'Expiry: ${card.expiryDate}',
//                         style: const TextStyle(fontSize: 12.0),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) => const SizedBox(width: 10.0),
//           ),
//         ),
//         const Divider(),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Enter New Card Details',
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               TextField(
//                 controller: widget.cardNumberController,
//                 decoration: const InputDecoration(
//                   labelText: 'Card Number',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: widget.expiryDateController,
//                       decoration: const InputDecoration(
//                         labelText: 'Expiration Date',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10.0),
//                   Expanded(
//                     child: TextField(
//                       controller: widget.cvvController,
//                       decoration: const InputDecoration(
//                         labelText: 'CVV',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCardImage(CardType type) {
//     switch (type) {
//       case CardType.mastercard:
//         return Image.asset('assets/mastercard.jpg', height: 40);
//       case CardType.visa:
//         return Image.asset('assets/visa.png', height: 18);
//       case CardType.paypal:
//         return Image.asset('assets/PayPal.png', height: 40);
//       default:
//         return const SizedBox();
//     }
//   }
// }





import 'package:fam1/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:fam1/Screens/Cartsection/card_model.dart';


class PaymentPage extends StatefulWidget {
  final TextEditingController cardNumberController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvController;

  const PaymentPage({
    Key? key,
    required this.cardNumberController,
    required this.expiryDateController,
    required this.cvvController,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<CardModel> previousCards = []; // Initialize an empty list to store previous cards
  DatabaseController _paymentService = DatabaseController(); // Create an instance of PaymentService

  @override
  void initState() {
    super.initState();
    // Call fetchPaymentMethods when the page is initialized
    _fetchPaymentMethods();
  }
Future<void> _fetchPaymentMethods() async {
  try {
    List<Map<String, dynamic>> fetchedMethods =
        await _paymentService.fetchPayments();
    List<CardModel> cards = fetchedMethods.map((method) {
      return CardModel(
        cardNumber: method['accountNumber'] ?? '', // Use 'accountNumber' as card number
        expiryDate: method['expiryDate'] ?? '', // Use 'expiryDate' as expiry date
        cvv: method['cvv'] ?? '', // Use 'cvv' as CVV
        type: CardType.other, // Set card type to other (you can adjust this based on your data)
      );
    }).toList();
    setState(() {
      previousCards = cards; // Update previousCards list with parsed cards
    });
  } catch (e) {
    print('Error fetching payment methods: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        SizedBox(
          height: 150, // Adjust the height according to your design
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: previousCards.length,
            itemBuilder: (context, index) {
              final card = previousCards[index];
              return InkWell(
                onTap: () {
                  // Set selected card details in the form fields
                  widget.cardNumberController.text = card.cardNumber;
                  widget.expiryDateController.text = card.expiryDate;
                  widget.cvvController.text = card.cvv;
                },
                child: Container(
                  width: 120, // Adjust the width according to your design
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCardImage(card.type),
                      Text(
                        'Card ending in ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                        style: const TextStyle(fontSize: 12.0),
                      ),
                      Text(
                        'Expiry: ${card.expiryDate}',
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10.0),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter New Card Details',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: widget.cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.expiryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Expiration Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: widget.cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardImage(CardType type) {
    switch (type) {
      case CardType.mastercard:
        return Image.asset('assets/mastercard.jpg', height: 40);
      case CardType.visa:
        return Image.asset('assets/visa.png', height: 18);
      case CardType.paypal:
        return Image.asset('assets/PayPal.png', height: 40);
      default:
        return const SizedBox();
    }
  }
}
