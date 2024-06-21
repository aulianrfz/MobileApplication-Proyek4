import 'package:flutter/material.dart';
import 'api_service.dart';
import 'history_data.dart';

class HistoryPage extends StatelessWidget {
  Future<List<HistoryData>> _fetchHistory() async {
    return await ApiService.fetchHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<HistoryData>>(
        future: _fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load history data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history data available'));
          } else {
            return ListView(
              padding: EdgeInsets.all(20),
              children: snapshot.data!.map((history) {
                return _buildIntegrationItem(
                  context,
                  history.appName,
                  '${history.generatedAt.toLocal()}'.split(' ')[0],
                  '${history.generatedAt.toLocal()}'
                      .split(' ')[1]
                      .substring(0, 5),
                  history.status ==
                      'Login successful', // Menyesuaikan kondisi kesuksesan
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                '$appName',
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
