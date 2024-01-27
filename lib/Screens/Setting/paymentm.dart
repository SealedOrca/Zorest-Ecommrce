import 'package:flutter/material.dart';

class PaymentMethodPage extends StatefulWidget {
  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Credit Card',
      'image': 'assets/am.png',
      'details': '**** **** **** 1234',
    },
    {
      'name': 'PayPal',
      'image': 'assets/PayPal.png',
      'details': 'john.doe@example.com',
    },
    {
      'name': 'Google Pay',
      'image': 'assets/g.png',
      'details': 'john.doe@gmail.com',
    },
  ];

  Map<String, dynamic>? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            _buildPaymentMethodCards(),
            const SizedBox(height: 30.0),
            _buildOptionsButtons(),
            const SizedBox(height: 40.0),
            _buildProcessButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCards() {
    return Column(
      children: paymentMethods.map((method) {
        return GestureDetector(
          onTap: () {
            _selectPaymentMethod(method);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: selectedPaymentMethod == method
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: Image.asset(
                method['image'],
                width: 40.0,
                height: 40.0,
              ),
              title: Text(
                method['name'],
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(method['details']),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOptionsButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOptionButton('Add', Icons.add, Colors.white),
        _buildOptionButton('Delete', Icons.delete, Colors.white),
      ],
    );
  }

  Widget _buildOptionButton(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle option button logic
        if (label == 'Add') {
          _showAddPaymentDialog();
        } else if (label == 'Delete') {
          _deletePaymentMethod();
        }
      },
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _buildProcessButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 250, 253, 87),
            Color.fromARGB(255, 111, 255, 116)
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          _processPayment();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text(
          'Process Payment',
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }

  Future<void> _showAddPaymentDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController detailsController = TextEditingController();
    String selectedPaymentMethod = 'PayPal';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: 'Acount Name/Email'),
              ),
              TextFormField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: 'Acount Number'),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedPaymentMethod,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedPaymentMethod = newValue;
                    });
                  }
                },
                items: <String>['PayPal', 'American Express', 'Google Pay']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addPaymentMethod({
                  'name': nameController.text,
                  'image': _getImagePath(selectedPaymentMethod),
                  'details': detailsController.text,
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String _getImagePath(String paymentMethod) {
    switch (paymentMethod) {
      case 'PayPal':
        return 'assets/PayPal.png';
      case 'American Express':
        return 'assets/am.png';
      case 'Google Pay':
        return 'assets/g.png';
      default:
        return 'assets/mastercard.jpg'; // Change this to the default image path
    }
  }

  void _addPaymentMethod(Map<String, dynamic> newPaymentMethod) {
    setState(() {
      paymentMethods.add(newPaymentMethod);
    });
  }

  void _selectPaymentMethod(Map<String, dynamic> method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  void _deletePaymentMethod() {
    // Implement logic to delete the selected payment method
    if (selectedPaymentMethod != null) {
      setState(() {
        paymentMethods.remove(selectedPaymentMethod);
        selectedPaymentMethod = null;
      });
    }
  }

  void _processPayment() {
    // Implement logic to process payment using the selected payment method
    if (selectedPaymentMethod != null) {
      _showPaymentConfirmationDialog();
    }
  }

  Future<void> _showPaymentConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: const Text('Thank you for your purchase!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: PaymentMethodPage(),
    ),
  );
}
