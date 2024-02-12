import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoomBookingPage()),
                );
              },
              child: Text('Book a Room'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add navigation to other features like profile, notifications, etc.
              },
              child: Text('Other Features'),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomBookingPage extends StatefulWidget {
  @override
  _RoomBookingPageState createState() => _RoomBookingPageState();
}

class _RoomBookingPageState extends State<RoomBookingPage> {
  List<String> rooms = ['Single Room', 'Double Room', 'Dormitory'];

  String selectedRoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedRoom,
              onChanged: (String value) {
                setState(() {
                  selectedRoom = value;
                });
              },
              items: rooms.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Room Type'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Proceed to payment
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(selectedRoom)),
                );
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final String selectedRoom;

  PaymentPage(this.selectedRoom);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Razorpay _razorpay;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    print("Payment Success: ${response.paymentId}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentSuccessPage()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print("Payment Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print("External Wallet: ${response.walletName}");
  }

  void _openCheckout() {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': 2000, // amount in the smallest currency unit
      'name': 'Hostel Booking',
      'description': 'Room Booking Payment',
      'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Room: ${widget.selectedRoom}'),
            SizedBox(height: 20),
            Text('Payment Methods'),
            ElevatedButton(
              onPressed: () {
                _openCheckout();
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
      ),
      body: Center(
        child: Text('Payment Successful!'),
      ),
    );
  }
}
