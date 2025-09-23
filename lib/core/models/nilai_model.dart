enum SubjectCategory { diniyah, umum }

class Subject {
  final String name;
  final SubjectCategory category;

  Subject({required this.name, required this.category});
}

class StudentGradeProfile {
  final String studentId;
  final String namaLengkap;
  final String namaPanggilan;
  final String tempatLahir;
  final String tanggalLahir;
  final String kelas;
  final String jenisKelamin;
  final List<Subject> subjects;

  StudentGradeProfile({
    required this.studentId,
    required this.namaLengkap,
    required this.namaPanggilan,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.kelas,
    required this.jenisKelamin,
    required this.subjects,
  });

  // Factory for mock data
  factory StudentGradeProfile.createMock(String id, String name) {
    return StudentGradeProfile(
      studentId: id,
      namaLengkap: name,
      namaPanggilan: name.split(' ').first,
      tempatLahir: 'Malang',
      tanggalLahir: '22 Juli 2004',
      kelas: 'IX 9',
      jenisKelamin: 'Laki-Laki',
      subjects: [
        Subject(name: 'Tahfidz Qur’an', category: SubjectCategory.diniyah),
        Subject(name: 'Tahsin Qur’an', category: SubjectCategory.diniyah),
        Subject(name: 'Hadis', category: SubjectCategory.diniyah),
        Subject(name: 'Fiqih', category: SubjectCategory.diniyah),
        Subject(name: 'Matematika', category: SubjectCategory.umum),
        Subject(name: 'Bahasa Indonesia', category: SubjectCategory.umum),
        Subject(name: 'Bahasa Inggris', category: SubjectCategory.umum),
        Subject(name: 'Olahraga', category: SubjectCategory.umum),
      ],
    );
  }
}