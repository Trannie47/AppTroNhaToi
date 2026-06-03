String vietTat(String name) {
  List<String> arr = name.trim().split(" ");

  if (arr.length >= 2) {
    return "${arr.first[0]}${arr.last[0]}".toUpperCase();
  }

  return arr.first[0].toUpperCase();
}
