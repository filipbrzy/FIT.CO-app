
class PlanItem{
  int id = 0;
  String name = "";
  double progress = 0.0;

  PlanItem();

  void setName(String name) => this.name = name;
  
  bool isDone(){
    calculateProgress();
    return progress > 0.99;
  }

  void calculateProgress(){}
}