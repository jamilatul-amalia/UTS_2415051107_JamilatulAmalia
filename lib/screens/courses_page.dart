// Nama: Jamilatul Amalia
// NIM: 2415051107

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../models/course_state.dart';
import '../services/profile_service.dart';
import '../widgets/error_view.dart';
import '../widgets/role_guard.dart';
import 'add_course_page.dart';
import 'course_detail_page.dart';
import 'edit_course_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _userRole = 'seeker';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final profile = await ProfileService().getMyProfile();
    if (!mounted) return;
    if (profile != null) {
      setState(() {
        _userRole = profile.role;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context, Course course) async {
    final state = context.read<CourseState>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await state.removeCourse(course.code);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil dihapus!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus course'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();

    final filteredCourses = state.courses.where((course) {
      final q = _searchQuery.toLowerCase();
      return course.title.toLowerCase().contains(q) ||
          course.code.toLowerCase().contains(q);
    }).toList();

    Widget bodyContent;

    if (state.isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (state.error != null) {
      bodyContent = ErrorView(
        message: state.error!,
        onRetry: state.loadCourses,
      );
    } else if (state.courses.isEmpty) {
      bodyContent = const Center(child: Text('Data course belum tersedia'));
    } else {
      bodyContent = Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari nama atau kode mata kuliah...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: filteredCourses.isEmpty
                ? const Center(child: Text('Mata kuliah tidak ditemukan'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            course.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle:
                              Text('${course.code} • ${course.credits} SKS'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailPage(
                                  course: course,
                                  isFavorite: state.isFavorite(course.code),
                                ),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RoleGuard(
                                role: _userRole,
                                allowed: const ['owner', 'admin'],
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EditCoursePage(course: course),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _confirmDelete(context, course),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  state.isFavorite(course.code)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: state.isFavorite(course.code)
                                      ? Colors.red
                                      : null,
                                ),
                                onPressed: () =>
                                    state.toggleFavorite(course.code),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Katalog Mata Kuliah ($_userRole)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: bodyContent,
      floatingActionButton: RoleGuard(
        role: _userRole,
        allowed: const ['owner', 'admin'],
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddCoursePage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}