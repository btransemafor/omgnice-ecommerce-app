class SplitAddress {
  static Map<String, String> splitAddress(String fullAddress) {
    // Find positions
    int huyenIndex = fullAddress.indexOf('Huyen');
    int xaIndex = fullAddress.indexOf('Xa');

    // Extract parts
    String a = fullAddress.substring(0, huyenIndex).trim();
    String b = fullAddress.substring(huyenIndex, xaIndex).trim();
    String c = fullAddress.substring(xaIndex).trim();
    return {'tinh': a, 'huyen': b, 'xa': c}; 
  }
}
