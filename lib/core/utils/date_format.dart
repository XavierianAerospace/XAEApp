/// Formatea una fecha/hora (en hora local) como 'dd/MM/yyyy HH:mm', sin `intl`.
String formatDateTime(DateTime dt) {
  final l = dt.toLocal();
  String p(int n) => n.toString().padLeft(2, '0');
  return '${p(l.day)}/${p(l.month)}/${l.year} ${p(l.hour)}:${p(l.minute)}';
}
