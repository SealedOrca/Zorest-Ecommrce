import 'package:fam1/controller/controller.dart';
import 'package:flutter/material.dart';

class PaymentMethodPage extends StatefulWidget {
  final String userId;

  const PaymentMethodPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  List<Map<String, Object>> paymentMethods = [];
  Map<String, Object>? selectedPaymentMethod;
  final DatabaseController _databaseController = DatabaseController();

  @override
  void initState() {
    super.initState();
    _fetchPaymentMethods();
  }

  Future<void> _fetchPaymentMethods() async {
    try {
      List<Map<String, dynamic>> fetchedMethods =
          await _databaseController.fetchPayments();
      List<Map<String, Object>> parsedMethods = [];
      for (var method in fetchedMethods) {
        Map<String, Object> parsedMethod = {
          'name': method['name'] ?? 'Unknown',
          'accountNumber': method['accountNumber'] ?? '',
          'expiryDate': method['expiryDate'] ?? '',
          'cvv': method['cvv'] ?? '',
        };
        parsedMethods.add(parsedMethod);
      }
      setState(() {
        paymentMethods = parsedMethods;
      });
    } catch (e) {
      print('Error fetching payment methods: $e');
    }
  }

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
            Expanded(child: _buildPaymentMethodCards()),
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
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: paymentMethods.length,
      itemBuilder: (BuildContext context, int index) {
        final method = paymentMethods[index];
        return GestureDetector(
          onTap: () {
            _selectPaymentMethod(method);
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
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
              leading: _buildPaymentMethodIcon(method['name'] as String),
              title: Text(
                method['name'] as String,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Number: ${method['accountNumber']}'),
                  Text('Expiration Date: ${method['expiryDate']}'),
                  Text('CVV: ${method['cvv']}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionsButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOptionButton('Add', Icons.add, Colors.green),
        _buildOptionButton('Delete', Icons.delete, Colors.red),
      ],
    );
  }

  Widget _buildOptionButton(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        if (label == 'Add') {
          _showAddPaymentDialog();
        } else if (label == 'Delete') {
          _deletePaymentMethod();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
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
    );
  }

  Widget _buildPaymentMethodIcon(String paymentMethod) {
    switch (paymentMethod) {
      case 'PayPal':
        return const Icon(Icons.payment);
      case 'American Express':
        return const Icon(Icons.credit_card);
      case 'Google Pay':
        return const Icon(Icons.payment);
      default:
        return const Icon(Icons.credit_card);
    }
  }

  Future<void> _showAddPaymentDialog() async {
    TextEditingController accountNumberController = TextEditingController();
    TextEditingController expiryDateController = TextEditingController();
    TextEditingController cvvController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Payment Method'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: 'PayPal',
                      onChanged: (String? newValue) {},
                      items: <String>[
                        'PayPal',
                        'American Express',
                        'Google Pay',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              _buildPaymentMethodIcon(value),
                              const SizedBox(width: 10.0),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: accountNumberController,
                      decoration:
                          const InputDecoration(labelText: 'Account Number'),
                    ),
                    TextFormField(
                      controller: expiryDateController,
                      decoration:
                          const InputDecoration(labelText: 'Expiration Date'),
                    ),
                    TextFormField(
                      controller: cvvController,
                      decoration: const InputDecoration(labelText: 'CVV'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, Object> newPaymentMethod = {
                      
                      'accountNumber': accountNumberController.text,
                      'expiryDate': expiryDateController.text,
                      'cvv': cvvController.text,
                      'userId': widget.userId,
                    };
                    _addPaymentMethod(newPaymentMethod);
                    _databaseController.savePaymentMethod(newPaymentMethod);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addPaymentMethod(Map<String, Object> newPaymentMethod) {
    setState(() {
      paymentMethods.add(newPaymentMethod);
      selectedPaymentMethod = newPaymentMethod;
    });
  }

  void _selectPaymentMethod(Map<String, Object> method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  Future<void> _deletePaymentMethod() async {
    if (selectedPaymentMethod != null) {
      final confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text(
                'Are you sure you want to delete this payment method?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
      if (confirmed == true) {
        setState(() {
          paymentMethods.remove(selectedPaymentMethod);
          selectedPaymentMethod = null;
        });
      }
    }
  }
}
