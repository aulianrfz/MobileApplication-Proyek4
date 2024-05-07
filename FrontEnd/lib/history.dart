import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Riwayat integrasi berdasarkan hari
          _buildIntegrationHistoryByDay(context, 'Today'),
          _buildIntegrationHistoryByDay(context, 'Yesterday'),
          _buildIntegrationHistoryByDay(context, 'Monday'),
          // Tambahkan riwayat integrasi lainnya di sini sesuai kebutuhan
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 20,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/homepage');
              },
            ),
            IconButton(
              icon: Icon(
                Icons.history,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                // Add your on-tap logic here
              },
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                // Add your on-tap logic here
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildIntegrationHistoryByDay(BuildContext context, String day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            day,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Riwayat integrasi
        _buildIntegrationItem(
            context, 'App Name 1', 'April 28, 2024', '10:00 AM', true),
        _buildIntegrationItem(
            context, 'App Name 2', 'April 28, 2024', '11:30 AM', false),
        // Tambahkan riwayat integrasi lainnya di sini sesuai kebutuhan
      ],
    );
  }

  Widget _buildIntegrationItem(BuildContext context, String appName,
      String date, String time, bool isSuccess) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width -
          40, // Lebar sesuai dengan lebar layar
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSuccess ? Colors.green[200] : Colors.red[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Name: $appName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Date: $date',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                'Time: $time',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            isSuccess ? 'Done' : 'Failed',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSuccess ? Colors.green[900] : Colors.red[900],
            ),
          ),
        ],
      ),
    );
  }
}
