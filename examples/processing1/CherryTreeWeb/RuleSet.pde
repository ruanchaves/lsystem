/*

L-system RuleSet Class
Built for FlashBelt 2005
blprnt@blprnt.com

Feel free to use it as you wish. Note that it is a very early version and may not work all that well.

Required Classes: Lsystem, RuleSet, Rule, Engine
Test implementation: Tester

*/

class RuleSet {

  Rule[] rules;
  int rulecount, test;
  
  RuleSet() {
    rulecount = 0;
    rules = new Rule[100];
  };
  
  void init() {
   
  };
  
  void addRule(Rule r) {
    rulecount ++;
    rules[rulecount] = r;
  };
  
   String runRule(char rid) {

      for (int i=1; i<=rulecount; i++){
      //println(i);
        if (char(rules[i].id)[0] == rid) {
          float dice = random(100);
          float chance = 0;
          boolean checked = false;
          int j = 0;
          while (!checked || j < 2) {
              String r = rules[i].rules[j];
              int prob = int(r.split(":")[1]);
              
              chance += float(prob);
              
              if (dice < chance) {
                checked = true;
                return(r.split(":")[0]);
              };
              
              j++;
              
          };
        };
      };
      return (str(rid));
   };
};

