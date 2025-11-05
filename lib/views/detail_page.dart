import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:my_personal_app/viewmodels/detail_viewmodel.dart';
import 'package:my_personal_app/viewmodels/home_viewmodel.dart'; 
import 'package:my_personal_app/views/widgets/profile_card.dart';

class DetailPage extends StatefulWidget {
  final String profileId;
  final bool isDuplicating; 

  const DetailPage({
    super.key, 
    required this.profileId, 
    this.isDuplicating = false
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _bioController = TextEditingController();
    _emailController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<DetailViewModel>(context, listen: false);
      
      if (widget.profileId == 'new') {
        viewModel.createEmptyProfile();
      } else {
        viewModel.loadProfile(widget.profileId, isDuplicating: widget.isDuplicating);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateControllers(DetailViewModel viewModel) {
    if (viewModel.userProfile != null) {
      _nameController.text = viewModel.userProfile!.name;
      _titleController.text = viewModel.userProfile!.title;
      _bioController.text = viewModel.userProfile!.bio;
      _emailController.text = viewModel.userProfile!.email;
    }
  }

  void _saveForm(DetailViewModel viewModel) {
    if (_formKey.currentState!.validate()) {
      viewModel.saveProfile(
        name: _nameController.text,
        title: _titleController.text,
        bio: _bioController.text,
        email: _emailController.text,
        skills: viewModel.userProfile?.skills ?? [], 
      );
      
      Provider.of<HomeViewModel>(context, listen: false).refreshProfiles();

      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DetailViewModel>(context);

    if (viewModel.userProfile == null && widget.profileId != 'new' && !widget.isDuplicating) {
      return Scaffold(
        appBar: AppBar(title: const Text("Завантаження...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (viewModel.userProfile != null) {
      _updateControllers(viewModel);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.isNewProfile || widget.isDuplicating 
          ? "Створення Резюме" 
          : "Редагування Резюме"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildTextField(_nameController, "Ім'я"),
              _buildTextField(_titleController, "Посада"),
              _buildTextField(_emailController, "Email", keyboardType: TextInputType.emailAddress),
              _buildTextField(_bioController, "Біографія", maxLines: 5),

              const SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: () => _saveForm(viewModel),
                child: const Text("ЗБЕРЕГТИ РЕЗЮМЕ"),
              ),
              
              const SizedBox(height: 30),

              if (viewModel.userProfile != null)
                ProfileCard(
                  userProfile: viewModel.userProfile!.copyWith(
                    name: _nameController.text,
                    title: _titleController.text,
                    bio: _bioController.text,
                    email: _emailController.text,
                  ),
                  title: "Попередній перегляд",
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Будь ласка, заповніть це поле';
          }
          return null;
        },
      ),
    );
  }
}