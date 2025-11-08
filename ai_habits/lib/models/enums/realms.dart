enum Realms {
  physical(name: 'Physical'),
  mental(name: 'Mental'),
  spiritual(name: 'Spiritual'),
  social(name: 'Social'),
  financial(name: 'Financial'),
  environmental(name: 'Environmental'),
  intellectual(name: 'Intellectual'),
  occupational(name: 'Occupational'),
  cultural(name: 'Cultural'),
  recreational(name: 'Recreational'),
  other(name: 'Other');

  final String name;
  const Realms({required this.name});
}
