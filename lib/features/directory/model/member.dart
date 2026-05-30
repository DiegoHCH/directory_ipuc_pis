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
  final String bio;
  final List<String> offers;

  const Member({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.category,
    this.bio = '',
    this.offers = const [],
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  factory Member.fromMap(String id, Map<String, dynamic> map) => Member(
        id: id,
        name: map['name'] as String? ?? '',
        description: map['description'] as String? ?? '',
        phone: map['phone'] as String? ?? '',
        category: MemberCategory.values.firstWhere(
          (c) => c.name == map['category'],
          orElse: () => MemberCategory.servicio,
        ),
        bio: map['bio'] as String? ?? '',
        offers: List<String>.from(map['offers'] as List? ?? []),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'phone': phone,
        'category': category.name,
        'bio': bio,
        'offers': offers,
      };

  Member copyWith({
    String? name,
    String? description,
    String? phone,
    MemberCategory? category,
    String? bio,
    List<String>? offers,
  }) =>
      Member(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        phone: phone ?? this.phone,
        category: category ?? this.category,
        bio: bio ?? this.bio,
        offers: offers ?? this.offers,
      );
}

const mockMembers = [
  Member(
    id: '1',
    name: 'Mariana Castro',
    description: 'Repostería Casera "Dulce Maná"',
    phone: '+57 311 412 8033',
    category: MemberCategory.emprendimiento,
    bio:
        'Hago tortas, panqués y postres para cumpleaños, baby showers y eventos de la iglesia. Trabajo con harinas integrales y endulzantes naturales cuando lo pides. Entrega en Bogotá zona norte, los pedidos se hacen con 3 días de anticipación.',
    offers: [
      'Tortas de cumpleaños',
      'Panqués caseros',
      'Postres sin azúcar',
      'Mesa de dulces',
      'Galletas decoradas',
    ],
  ),
  Member(
    id: '2',
    name: 'Daniel Ortiz',
    description: 'Diseño gráfico y web',
    phone: '+57 310 308 9921',
    category: MemberCategory.servicio,
    bio:
        'Diseñador con 8 años de experiencia en identidad visual, logotipos y sitios web. Trabajo con emprendedores y empresas pequeñas que quieren proyectar una imagen profesional sin gastar una fortuna.',
    offers: [
      'Logotipos',
      'Identidad de marca',
      'Páginas web',
      'Diseño para redes',
      'Tarjetas de presentación',
    ],
  ),
  Member(
    id: '3',
    name: 'Pastor Eliseo Ramírez',
    description: 'Asesoría familiar y consejería',
    phone: '+57 320 501 4476',
    category: MemberCategory.servicio,
    bio:
        'Ofrezco consejería bíblica para parejas, familias y jóvenes en momentos de crisis o búsqueda espiritual. Las sesiones son confidenciales y se realizan de forma presencial o virtual.',
    offers: [
      'Consejería de parejas',
      'Orientación juvenil',
      'Consejería familiar',
      'Acompañamiento espiritual',
    ],
  ),
  Member(
    id: '4',
    name: 'Carolina Vargas',
    description: 'Boutique Caro · Ropa modesta',
    phone: '+57 315 882 0034',
    category: MemberCategory.empresa,
    bio:
        'Tienda de ropa femenina con enfoque en moda modesta y elegante. Contamos con vestidos, blusas y conjuntos pensados para la mujer cristiana que quiere verse bien sin comprometer sus valores.',
    offers: [
      'Vestidos largos',
      'Blusas y camisas',
      'Conjuntos formales',
      'Ropa casual modesta',
      'Pedidos por encargo',
    ],
  ),
  Member(
    id: '5',
    name: 'Tomás Henríquez',
    description: 'Música y producción de audio',
    phone: '+57 312 774 5509',
    category: MemberCategory.arte,
    bio:
        'Productor musical con estudio propio. Grabo, mezclo y masterizo música cristiana, alabanzas y proyectos personales. También ofrezco clases de guitarra y teoría musical para todas las edades.',
    offers: [
      'Grabación de voz',
      'Mezcla y masterización',
      'Producción de alabanzas',
      'Clases de guitarra',
      'Jingles y cuñas',
    ],
  ),
  Member(
    id: '6',
    name: 'Sandra Peña',
    description: 'Costura y confección a medida',
    phone: '+57 318 221 0044',
    category: MemberCategory.emprendimiento,
    bio:
        'Confecciono ropa a medida para damas y niñas. Especializada en vestidos de gala, trajes de quinceañera y uniformes escolares. Trabajo con telas nacionales e importadas según el presupuesto del cliente.',
    offers: [
      'Vestidos de gala',
      'Uniformes escolares',
      'Arreglos de ropa',
      'Trajes de quinceañera',
    ],
  ),
  Member(
    id: '7',
    name: 'Luis Morales',
    description: 'Ferretería Los Andes',
    phone: '+57 314 663 9182',
    category: MemberCategory.empresa,
    bio:
        'Ferretería con más de 15 años en el sector. Contamos con materiales de construcción, herramientas eléctricas y todo lo necesario para remodelaciones. Atención a domicilio para proyectos grandes.',
    offers: [
      'Materiales de construcción',
      'Herramientas eléctricas',
      'Pinturas y acabados',
      'Asesoría en obra',
    ],
  ),
  Member(
    id: '8',
    name: 'Adriana Rojas',
    description: 'Fotografía y edición de video',
    phone: '+57 317 445 2270',
    category: MemberCategory.arte,
    bio:
        'Fotógrafa y videógrafa disponible para eventos de iglesia, bodas, quinceañeras y sesiones de familia. Entrego álbumes digitales en menos de una semana con edición profesional incluida.',
    offers: [
      'Fotografía de eventos',
      'Videos de bodas',
      'Sesiones familiares',
      'Álbumes digitales',
      'Reels para redes',
    ],
  ),
  Member(
    id: '9',
    name: 'Camilo Suárez',
    description: 'Plomería y reparaciones del hogar',
    phone: '+57 300 889 1234',
    category: MemberCategory.servicio,
    bio:
        'Técnico en plomería y mantenimiento de hogares. Reparo fugas, instalo sanitarios, cambio redes de gas y hago instalaciones eléctricas básicas. Atención en Bogotá y municipios cercanos.',
    offers: [
      'Reparación de fugas',
      'Instalación sanitaria',
      'Redes de gas',
      'Eléctrica básica',
      'Mantenimiento preventivo',
    ],
  ),
  Member(
    id: '10',
    name: 'Natalia Gómez',
    description: 'Clases de inglés y español',
    phone: '+57 313 556 7890',
    category: MemberCategory.servicio,
    bio:
        'Profesora bilingüe con experiencia en enseñanza para niños, jóvenes y adultos. Clases virtuales o presenciales adaptadas al nivel y objetivo de cada estudiante. Preparación para exámenes internacionales.',
    offers: [
      'Inglés básico',
      'Inglés conversacional',
      'Preparación IELTS/TOEFL',
      'Español para extranjeros',
      'Clases para niños',
    ],
  ),
];
