import 'package:flutter/material.dart';
import '../widgets/dashboard_tile.dart';
import 'spent_screen.dart';
import 'received_screen.dart';
import 'pending_screen.dart';
import '../data/dummy_entries.dart';
import '../utils/ledger_utils.dart';
import 'add_entry_screen.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spent = totalSpent(dummyEntries);
    final received = totalReceived(dummyEntries);
    final pending = pendingAmount(dummyEntries);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEntryScreen()),
    );
  },
  child: const Icon(Icons.add),
),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DashboardTile(
              icon: Icons.arrow_upward,
              title: 'Amount Spent',
              amount: spent,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SpentScreen(),
                  ),
                  );
                },
            ),
            const SizedBox(height: 16),
            DashboardTile(
              icon: Icons.arrow_downward,
              title: 'Amount Received',
              amount: received,
              color: Colors.green,
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReceivedScreen(),
                    ),
                  );
                },
            ),
            const SizedBox(height: 16),
            DashboardTile(
              icon: Icons.hourglass_bottom,
              title: 'Pending Amount',
              amount: pending,
              color: Colors.orange,
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PendingScreen(),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
