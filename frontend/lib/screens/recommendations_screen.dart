import 'package:flutter/material.dart';
import '../models/model.dart';
import '../services/service.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late Future<List<Recommendation>> _futureRecommendations;
  final RecommendationService _service = RecommendationService();

  @override
  void initState() {
    super.initState();
    _futureRecommendations = _service.fetchRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: FutureBuilder<List<Recommendation>>(
        future: _futureRecommendations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recomendations'));
          }
          final recommendations = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: recommendations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(rec.title, style: Theme.of(context).textTheme.bodyLarge),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(rec.description),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 
