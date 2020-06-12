class Utils {
  static getUsername(String email) {
    return "Id:${email.split("@")[0]}";
  }

  static getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    return (nameSplit[0][0] + nameSplit[1][0]).toUpperCase();
  }
}
