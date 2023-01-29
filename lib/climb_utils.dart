class ClimbUtils{
  static String getLevel(int level){
    switch(level){
      case 0:
        return "Low";
      case 1:
        return "Mid";
      case 2:
        return "High";
      case 3:
        return "Traversal";
      default:
        return "None";
    }
  }
}