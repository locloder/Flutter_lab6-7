import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:my_personal_app/viewmodels/home_viewmodel.dart';
import 'package:my_personal_app/models/user_profile.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    viewModel.loadProfiles(); 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Список Резюме"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.profiles.length,
              itemBuilder: (context, index) {
                final profile = viewModel.profiles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(profile.name),
                    subtitle: Text(profile.title),
                    trailing: _buildPopupMenu(context, profile), 
                    onTap: () {
                      context.go('/detail/${profile.id}'); 
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.code),
              label: const Text("Перейти до GitHub Статистики"),
              onPressed: () {
                context.go('/github-stats'); 
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/detail/new');
        },
        tooltip: 'Створити нове резюме',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, UserProfile profile) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        if (result == 'duplicate') {
          context.go('/detail/duplicate/${profile.id}'); 
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'duplicate',
          child: Text('Дублювати'),
        ),
      ],
    );
  }
}