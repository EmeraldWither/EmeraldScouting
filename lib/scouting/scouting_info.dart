import 'dart:convert';

class ScoutingInfo{
  int teamNum;
  int lowCargo;
  int highCargo;
  int climbLevel;
  int matchNumber;
  int rating;
  ScoutingInfo({required this.lowCargo, required this.highCargo, required this.climbLevel, required this.matchNumber, required this.teamNum, required this.rating});

  int get getTotalScore {
    int totalScore = (lowCargo) + (highCargo * 2);

    switch (climbLevel) {
      case 0:
        totalScore += 4;
        break;
      case 1:
        totalScore += 6;
        break;
      case 2:
        totalScore += 10;
        break;
      case 3:
        totalScore += 15;
        break;
      default:
        break;
    }
    return totalScore;
  }
  @override
  String toString(){
    return jsonEncode({
      'teamNumber': teamNum,
      'lowCargo': lowCargo,
      'highCargo': highCargo,
      'climbLevel': climbLevel,
      'matchNumber': matchNumber,
      'rating': rating,
    });
  }
}