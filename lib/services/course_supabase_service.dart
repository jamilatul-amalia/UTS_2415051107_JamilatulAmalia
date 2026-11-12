// Nama: Jamilatul Amalia
// NIM: 2415051107

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  String? get _uid => supabase.auth.currentUser?.id;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase
        .from('courses')
        .select()
        .order('id');

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final Map<String, dynamic> payload = {
      if (_uid != null) 'owner_id': _uid,
      'code': course.code.toUpperCase(),
      'title': course.title,
      'credits': course.credits,
      'status': course.status.toLowerCase(),
    };

    final row = await supabase
        .from('courses')
        .insert(payload)
        .select()
        .single();

    return Course.fromJson(row);
  }

  @override
  Future<Course> updateCourse(String id, Course course) async {
    try {
      final Map<String, dynamic> payload = {
        'code': course.code.toUpperCase(),
        'title': course.title,
        'credits': course.credits,
        'status': course.status.toLowerCase(),
      };

      final int? parsedId = int.tryParse(id) ?? int.tryParse(course.id.toString());

      var query = supabase.from('courses').update(payload);

      final response = await (parsedId != null && parsedId > 0
              ? query.eq('id', parsedId)
              : query.eq('code', course.code.toUpperCase()))
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception(
            "Akses ditolak oleh RLS atau data course tidak ditemukan.");
      }

      return Course.fromJson(response);
    } catch (e) {
      debugPrint("ERROR SUPABASE UPDATE: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteCourse(String id) async {
    try {
      final int? parsedId = int.tryParse(id);
      final rows = await (parsedId != null && parsedId > 0
              ? supabase.from('courses').delete().eq('id', parsedId)
              : supabase.from('courses').delete().eq('code', id.toUpperCase()))
          .select();

      if (rows.isEmpty) {
        throw Exception(
            "Akses ditolak oleh RLS atau data course tidak ditemukan.");
      }
    } catch (e) {
      debugPrint("ERROR SUPABASE DELETE: $e");
      rethrow;
    }
  }
}