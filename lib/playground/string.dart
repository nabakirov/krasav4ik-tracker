String address = '0x2e8dA0868e46fc943766a98b8D92A0380B29CE2A';
double deviceWidth = 411;

void main() async {
  // var items = [1,3,4,5,6,8,3,2,5];
  print(1.compareTo(1));
  // print(toShort(address, deviceWidth));
}

String toShort(String address, double width) {
  int length = address.length;
  String shorten = address.substring(0, 7) + '...' + address.substring(length - 7, length);
  return shorten;
}

