enum MemberCategory { all, empresa, emprendimiento, arte, servicio }

extension MemberCategoryLabel on MemberCategory {
  String get label => switch (this) {
        MemberCategory.all => 'Todos',
        MemberCategory.empresa => 'Empresa',
        MemberCategory.emprendimiento => 'Emprendimiento',
        MemberCategory.arte => 'Arte',
        MemberCategory.servicio => 'Servicio',
      };

  String get tag => switch (this) {
        MemberCategory.all => 'TODOS',
        MemberCategory.empresa => 'EMPRESA',
        MemberCategory.emprendimiento => 'EMPRENDIMIENTO',
        MemberCategory.arte => 'ARTE',
        MemberCategory.servicio => 'SERVICIO',
      };
}

class Member {
  final String id;
  final String name;
  final String description;
  final String phone;
  final MemberCategory category;

  const Member({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.category,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }
}

const mockMembers = [
  Member(
    id: '1',
    name: 'Mariana Castro',
    description: 'Repostería Casera "Dulce Maná"',
    phone: '+57 311 412 8033',
    category: MemberCategory.emprendimiento,
  ),
  Member(
    id: '2',
    name: 'Daniel Ortiz',
    description: 'Diseño gráfico y web',
    phone: '+57 310 308 9921',
    category: MemberCategory.servicio,
  ),
  Member(
    id: '3',
    name: 'Pastor Eliseo Ramírez',
    description: 'Asesoría familiar y consejería',
    phone: '+57 320 501 4476',
    category: MemberCategory.servicio,
  ),
  Member(
    id: '4',
    name: 'Carolina Vargas',
    description: 'Boutique Caro · Ropa modesta',
    phone: '+57 315 882 0034',
    category: MemberCategory.empresa,
  ),
  Member(
    id: '5',
    name: 'Tomás Henríquez',
    description: 'Música y producción de audio',
    phone: '+57 312 774 5509',
    category: MemberCategory.arte,
  ),
  Member(
    id: '6',
    name: 'Sandra Peña',
    description: 'Costura y confección a medida',
    phone: '+57 318 221 0044',
    category: MemberCategory.emprendimiento,
  ),
  Member(
    id: '7',
    name: 'Luis Morales',
    description: 'Ferretería Los Andes',
    phone: '+57 314 663 9182',
    category: MemberCategory.empresa,
  ),
  Member(
    id: '8',
    name: 'Adriana Rojas',
    description: 'Fotografía y edición de video',
    phone: '+57 317 445 2270',
    category: MemberCategory.arte,
  ),
  Member(
    id: '9',
    name: 'Camilo Suárez',
    description: 'Plomería y reparaciones del hogar',
    phone: '+57 300 889 1234',
    category: MemberCategory.servicio,
  ),
  Member(
    id: '10',
    name: 'Natalia Gómez',
    description: 'Clases de inglés y español',
    phone: '+57 313 556 7890',
    category: MemberCategory.servicio,
  ),
];
