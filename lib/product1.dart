import 'package:flutter/material.dart';

class Product1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Getting the screen width using mediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    // base font size and adjust based on screen width
    double baseFontSize = 14.0;
    double adjustedFontSize = baseFontSize + (screenWidth * 0.01);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Color(0xFF978D4F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'images/ethiqueshampoo1.png',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Clarifying Shampoo Bar for Oily Scalp and Hair',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: adjustedFontSize + 2.0, // a bit larger for the title
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                'Price: LKR 1750.00',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: adjustedFontSize + 1.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'This clarifying shampoo bar is perfect for oily scalps. '
                    'Lift away impurities with lime and orange essential oils. '
                    'Your hair will feel fresh and full!',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: adjustedFontSize,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              SizedBox(height: 24.0),

              // Quantity part
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _quantityButton(Icons.remove),
                  SizedBox(width: 8.0),
                  Text(
                    '1', // initial quantity
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: adjustedFontSize,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  _quantityButton(Icons.add),
                ],
              ),

              SizedBox(height: 16.0),

              // Dropdown list for sizes
              Text(
                'Select Size',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: adjustedFontSize + 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              _dropdownOption(),

              SizedBox(height: 24.0),

              Text(
                "Similar Shampoo Products",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                  fontSize: adjustedFontSize + 2.0,
                ),
              ),

              // horizontal gallery part
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.asset(
                        'images/eshampoo.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16.0),
                      Image.asset(
                        'images/ethiqueshampoo5.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16.0),
                      Image.asset(
                        'images/ethiqueshampoo4.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16.0),
                      Image.asset(
                        'images/ethiqueshampoo2.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quantityButton(IconData icon) {
    return Container(
      height: 32.0,
      width: 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20.0),
        onPressed: () {

        },
      ),
    );
  }

  Widget _dropdownOption() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: SizedBox(),
        value: 'Small', // set to 'small'
        items: <String>['Small', 'Medium'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {

        },
      ),
    );
  }
}
