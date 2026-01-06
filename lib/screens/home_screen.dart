import 'package:flutter/material.dart';
import '../widgets/dashboard_tile.dart';
import 'spent_screen.dart';
import 'received_screen.dart';
import 'pending_screen.dart';
import 'add_entry_screen.dart';
import '../database/ledger_database.dart';
import '../models/entry.dart';
import '../utils/ledger_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Entry>> _futureEntries;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _futureEntries = LedgerDatabase.instance.getAllEntries();
  }

  Future<void> _refresh() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEntryScreen()),
          );
          setState(_load);
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Entry>>(
          future: _futureEntries,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                children: [
                  SizedBox(height: 200),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }

            final entries = snapshot.data ?? [];

            final spent = totalSpent(entries);
            final received = totalReceived(entries);
            final pending = pendingAmount(entries);

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DashboardTile(
                      icon: Icons.arrow_upward,
                      title: 'Amount Spent',
                      amount: spent,
                      color: Colors.red,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SpentScreen(),
                          ),
                        );
                        setState(_load);
                      },
                    ),
                    const SizedBox(height: 16),
                    DashboardTile(
                      icon: Icons.arrow_downward,
                      title: 'Amount Received',
                      amount: received,
                      color: Colors.green,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReceivedScreen(),
                          ),
                        );
                        setState(_load);
                      },
                    ),
                    const SizedBox(height: 16),
                    DashboardTile(
                      icon: Icons.hourglass_bottom,
                      title: 'Pending Amount',
                      amount: pending,
                      color: Colors.orange,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PendingScreen(),
                          ),
                        );
                        setState(_load);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
