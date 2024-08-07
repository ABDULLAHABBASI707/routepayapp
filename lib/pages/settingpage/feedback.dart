import 'package:flutter/material.dart';

class TermsPrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to Route Pay! By using our app, you agree to comply with and be bound by the following terms of service. Please review them carefully.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '1. Online Ride Booking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our app allows you to book rides online with customizable fare options. By booking a ride, you agree to our pricing and payment terms.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2. Fare Customization',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You can customize fares for local transport through our fare calculator feature. Ensure to input accurate details for precise fare calculation.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3. Trip Planning',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Plan your trips in advance using our online trip planning feature. We offer advanced tools to make your planning efficient and user-friendly.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We are committed to protecting your privacy. This policy outlines how we collect, use, and protect your information.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '1. Data Collection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We collect personal information such as name, contact details, and location data to provide our services effectively.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2. Data Usage',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Your data is used to facilitate ride bookings, calculate fares, and improve our services. We do not share your data with third parties without your consent.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3. Data Protection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We implement security measures to protect your data from unauthorized access. Your data is stored securely and encrypted.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '4. User Rights',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You have the right to access, modify, or delete your personal information. Contact us at support@routepay.com for any data-related inquiries.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'If you have any questions about our Terms of Service or Privacy Policy, please contact us at support@routepay.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
