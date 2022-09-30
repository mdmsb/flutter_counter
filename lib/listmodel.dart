class Tasb {
  String? id;
  String? tasbeehText;

  Tasb({
    required this.id,
    required this.tasbeehText,
  });

  static List<Tasb> tasbeeh() {
    return [
      Tasb(id: '01', tasbeehText: 'Subhanallah'),
      Tasb(id: '02', tasbeehText: 'Alhamdulillah'),
      Tasb(id: '03', tasbeehText: 'Allahuakbar'),
    ];
  }
}
