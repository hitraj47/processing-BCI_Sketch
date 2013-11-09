String neurosky[];

void setup() {
  size(900,700);
  neurosky = loadStrings("neurosky.json");
}

void draw() {
  
  for (int i = 0; i < neurosky.length; i++) {
    String line = neurosky[i];
    if (line.contains("rawEeg")) {
      JSONObject jsonObject = JSONObject.parse(line);
      //println(jsonObject.getInt("rawEeg"));
    } else if (line.contains("eSense")) {
      JSONObject eSense = JSONObject.parse(line);
    } else if (line.contains("poorSignalLevel")) {
      JSONObject jsonObject = JSONObject.parse(line);
    }
  }
  
}
