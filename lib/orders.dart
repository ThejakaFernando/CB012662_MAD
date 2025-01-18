import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String? authToken;

  Future<void> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString('auth_token');
    });
  }

  Future<void> fetchOrders() async {
    if (authToken == null) {
      print('Auth token not found');
      return;
    }

    final url = "http://134.209.152.31/api/user/orders";
    final response = await http.post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $authToken"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        orders = data['orders']['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load orders');
    }
  }

  @override
  void initState() {
    super.initState();
    getAuthToken().then((_) => fetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        backgroundColor: Color(0xFFAEA466),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? Center(
        child: Text(
          'You have no past orders...',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, index) {
          final order = orders[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final dynamic order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    final pendingColor = brightness == Brightness.dark ? Colors.grey[700] : Colors.grey[300];
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final statusTextColor = order['status'] == 'PENDING' ? textColor : (order['status'] == 'Completed' ? Colors.green : Colors.red);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order by: ${order['name']}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                if (order['status'] == 'PENDING')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: pendingColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusTextColor,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Email: ${order['email']}",
              style: TextStyle(
                color: brightness == Brightness.dark ? Colors.white70 : Colors.black87,
              ),
            ),
            Text(
              "Address: ${order['address']}",
              style: TextStyle(
                color: brightness == Brightness.dark ? Colors.white70 : Colors.black87,
              ),
            ),
            Text(
              "City: ${order['city']}, ${order['postal_code']}",
              style: TextStyle(
                color: brightness == Brightness.dark ? Colors.white70 : Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            // Payment Method
            Text(
              "Payment Method: ${order['payment_method']}",
              style: TextStyle(
                fontSize: 16,
                color: brightness == Brightness.dark ? Colors.white70 : Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            // Order Total
            Text(
              "Total: \$${order['total']}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: brightness == Brightness.dark ? Colors.green[300] : Colors.green,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Items:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            ...((order['items'] is List)
                ? order['items'].map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.shopping_bag,
                    color: brightness == Brightness.dark ? Colors.white : Color(0xFFAEA466),
                  ),
                  title: Text(
                    "${item['product_name']} (x${item['quantity']})",
                    style: TextStyle(
                      color: brightness == Brightness.dark ? Colors.white : Colors.black87,
                    ),
                  ),
                  trailing: Text(
                    "\$${item['price']}",
                    style: TextStyle(
                      color: brightness == Brightness.dark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList()
                : (order['items'] is Map)
                ? order['items'].entries.map<Widget>((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.shopping_bag,
                    color: brightness == Brightness.dark ? Colors.white : Color(0xFFAEA466),
                  ),
                  title: Text(
                    "${entry.value['product_name']} (x${entry.value['quantity']})",
                    style: TextStyle(
                      color: brightness == Brightness.dark ? Colors.white : Colors.black87,
                    ),
                  ),
                  trailing: Text(
                    "\$${entry.value['price']}",
                    style: TextStyle(
                      color: brightness == Brightness.dark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList()
                : []),
            Divider(),
          ],
        ),
      ),
    );
  }
}
