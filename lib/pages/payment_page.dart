import 'package:flutter/material.dart';
import 'package:gietsmart/pages/downloads_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatefulWidget {
  final String studentName;
  final String rollNumber;
  final String amount;

  const PaymentPage({
    super.key,
    required this.studentName,
    required this.rollNumber,
    required this.amount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  bool _isProcessing = false;
  String? _transactionId;
  bool _showAddCard = false;

  // Card details controllers
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _saveCard = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ignore: unused_field
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Credit Card',
      'icon': Icons.credit_card,
      'color': Colors.blue,
      'description': 'Pay with credit card',
    },
    {
      'name': 'Debit Card',
      'icon': Icons.credit_card,
      'color': Colors.green,
      'description': 'Pay with debit card',
    },
    {
      'name': 'Net Banking',
      'icon': Icons.account_balance,
      'color': Colors.orange,
      'description': 'Pay through net banking',
    },
    {
      'name': 'UPI',
      'icon': Icons.payment,
      'color': Colors.purple,
      'description': 'Pay using UPI',
    },
    {
      'name': 'PhonePe',
      'icon': Icons.phone_android,
      'color': Colors.indigo,
      'description': 'Pay with PhonePe',
    },
    {
      'name': 'Google Pay',
      'icon': Icons.g_mobiledata,
      'color': Colors.red,
      'description': 'Pay with Google Pay',
    },
    {
      'name': 'Paytm',
      'icon': Icons.payment,
      'color': Colors.blue,
      'description': 'Pay with Paytm',
    },
  ];

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      _transactionId = const Uuid().v4();
      await _generateReceipt();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful! Receipt downloaded.'),
            backgroundColor: Color(0xFF4A2D8B),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DownloadsPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _generateReceipt() async {
    final pdf = pw.Document();
    final now = DateTime.now();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Payment Receipt',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Transaction ID: $_transactionId'),
            pw.Text('Date: ${now.toString().split('.')[0]}'),
            pw.SizedBox(height: 20),
            pw.Text('Student Details:'),
            pw.Text('Name: ${widget.studentName}'),
            pw.Text('Roll Number: ${widget.rollNumber}'),
            pw.SizedBox(height: 20),
            pw.Text('Payment Details:'),
            pw.Text('Amount: ₹${widget.amount}'),
            pw.Text('Payment Method: $_selectedPaymentMethod'),
            pw.SizedBox(height: 20),
            pw.Text(
              'Status: Paid',
              style: pw.TextStyle(
                color: PdfColors.green,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/payment_receipt_${_transactionId}.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8A2BE2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _showAddCard ? 'Add New Card' : 'Payment Methods',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _showAddCard ? _buildAddCardScreen() : _buildPaymentMethodsScreen(),
    );
  }

  Widget _buildPaymentMethodsScreen() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSavedCards(),
            const SizedBox(height: 30),
            const Text(
              'Other Payment Methods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            _buildPaymentMethodsList(),
            const SizedBox(height: 40),
            _buildAmountSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedCards() {
    return Container(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildAddCardButton(),
          _buildCreditCard(
            cardNumber: '**** **** **** 2312',
            expiryDate: '02/11',
            holderName: 'RAKESH PRADHAN',
            isDebit: true,
          ),
          _buildCreditCard(
            cardNumber: '**** **** **** 8250',
            expiryDate: '05/28',
            holderName: 'RAKESH PRADHAN',
            isDebit: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAddCardButton() {
    return GestureDetector(
      onTap: () {
        setState(() => _showAddCard = true);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 40, color: Color(0xFF8A2BE2)),
            SizedBox(height: 10),
            Text(
              'Add New Card',
              style: TextStyle(
                color: Color(0xFF8A2BE2),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard({
    required String cardNumber,
    required String expiryDate,
    required String holderName,
    required bool isDebit,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF8A2BE2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Icon(Icons.contactless, color: Colors.white, size: 30),
            ],
          ),
          const Spacer(),
          Text(
            cardNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    isDebit ? 'Debit Card' : 'Credit Card',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                expiryDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsList() {
    final paymentMethods = [
      {'icon': Icons.credit_card, 'title': 'Credit / Debit Card'},
      {'icon': Icons.account_balance, 'title': 'Net Banking'},
      {'icon': Icons.account_balance_wallet, 'title': 'Google Wallet'},
      {'icon': Icons.phone_android, 'title': 'PhonePe'},
      {'icon': Icons.account_balance_wallet, 'title': 'Other Wallets'},
    ];

    return Column(
      children: paymentMethods.map((method) {
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(method['icon'] as IconData,
                color: const Color(0xFF8A2BE2)),
          ),
          title: Text(
            method['title'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            setState(() => _selectedPaymentMethod = method['title'] as String);
          },
        );
      }).toList(),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Amount to Pay',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              Text(
                '₹${widget.amount}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A2BE2),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A2BE2),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCardScreen() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreviewCard(),
            const SizedBox(height: 30),
            _buildCardForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF8A2BE2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Icon(Icons.contactless, color: Colors.white, size: 30),
            ],
          ),
          const Spacer(),
          Text(
            _cardNumberController.text.isEmpty
                ? '**** **** **** ****'
                : _cardNumberController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text.isEmpty
                        ? 'CARD HOLDER'
                        : _nameController.text.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Debit Card',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                _expiryController.text.isEmpty
                    ? 'MM/YY'
                    : _expiryController.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Number',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              hintText: '2323 5456 8732 6145',
              suffixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.credit_card,
                  color: Color(0xFF8A2BE2),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expiry Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        hintText: '05/27',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CVV',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        hintText: '523',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Name on Card',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'RAKESH PRADHAN',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: _saveCard,
                onChanged: (value) {
                  setState(() => _saveCard = value ?? false);
                },
                activeColor: const Color(0xFF8A2BE2),
              ),
              const Text(
                'Securely save card and details',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaymentIcon(Icons.credit_card, 'Visa'),
              const SizedBox(width: 20),
              _buildPaymentIcon(Icons.credit_card, 'Mastercard'),
              const SizedBox(width: 20),
              _buildPaymentIcon(Icons.credit_card, 'Amex'),
              const SizedBox(width: 20),
              _buildPaymentIcon(Icons.credit_card, 'Discover'),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _showAddCard = false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A2BE2),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Add Card',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentIcon(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF8A2BE2),
        size: 24,
      ),
    );
  }
}
