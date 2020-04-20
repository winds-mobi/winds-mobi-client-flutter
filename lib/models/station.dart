class StationModel {
  static const _stations = [
    Station(1, 'Le Suchet'),
    Station(2, 'Mauborget'),
    Station(3, 'Zinal'),
  ];

  Station getByID(int id) => _stations.singleWhere((station) => station.id == id);
}

class Station {
  final int id;
  final String name;

  const Station(this.id, this.name);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Station && other.id == id;
}
