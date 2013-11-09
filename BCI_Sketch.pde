String neurosky[];

void setup() {
  neurosky = loadStrings("neurosky.json");
}

void draw() {
  
  for (int i = 0; i < neurosky.length; i++) {
    String line = neurosky[i];
    if (line.contains("rawEeg")) {
      JSONObject rawEeg = JSONObject.parse(line);
      println(rawEeg.getInt("rawEeg"));
    }
  }
  
}
