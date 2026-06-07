import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/services/geocoding_api.dart';
import '../providers/saved_locations_provider.dart';
import '../widgets/skeu_card.dart';
import '../widgets/skeu_button.dart';
import '../core/theme/colors.dart';
import '../models/location.dart';

final geocodingApiServiceProvider = Provider((ref) => GeocodingApiService());

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  List<LocationModel> _results = [];
  bool _isLoading = false;

  void _onSearch() async {
    if (_controller.text.isEmpty) return;
    FocusScope.of(context).unfocus();
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final results = await ref.read(geocodingApiServiceProvider).searchCity(_controller.text);
      if (!mounted) return;
      setState(() => _results = results);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Search failed')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedCount = ref.watch(savedLocationsProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Location'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: SkeuCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    borderRadius: 12,
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        hintText: 'Enter city name...',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _onSearch(),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                SkeuButton(
                  onTap: _onSearch,
                  borderRadius: 12,
                  child: const Icon(Icons.search_rounded, color: AppColors.accent),
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(color: AppColors.accent, backgroundColor: AppColors.surface),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final loc = _results[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SkeuCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Text(loc.flagEmoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(loc.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 18)),
                              Text(loc.country ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        SkeuButton(
                          onTap: () async {
                            if (savedCount >= 2) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Maximum 3 locations total allowed')),
                              );
                            } else {
                              await ref.read(savedLocationsProvider.notifier).addLocation(loc);
                              if (context.mounted) context.pop();
                            }
                          },
                          color: savedCount >= 2 ? Colors.grey.withValues(alpha: 0.1) : AppColors.surface,
                          child: Text(
                            'ADD', 
                            style: TextStyle(
                              color: savedCount >= 2 ? Colors.grey : AppColors.accent, 
                              fontWeight: FontWeight.w900,
                              fontSize: 12
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
