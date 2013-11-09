String neurosky[];
int rawEegMin = Integer.MAX_VALUE;
int rawEegMax = Integer.MIN_VALUE;
ArrayList<Integer> rawEegValues;

void setup() {
  size(1100,700);
  neurosky = loadStrings("neurosky.json");
  rawEegValues = new ArrayList<Integer>();
  loadData();
  for (Integer v : rawEegValues) {
    println(v);
  }
}

void draw() {
  drawLineGraph();
  drawBarGraph(); 
  drawEegValues();
}

void drawEegValues() {
  for (int i = 0; i < rawEegValues.size(); i++) {
    float x1 = map(i, 0, rawEegValues.size(), 0, width);
    float y1 = map(rawEegValues.get(i), rawEegMin, rawEegMax, 0, height/2);
    y1 = height/2 - y1;
    i = i+1;
    float x2 = map(i, 0, rawEegValues.size(), 0, width);
    float y2 = map(rawEegValues.get(i), rawEegMin, rawEegMax, 0, height/2);
    y2 = height/2 - y2;
  }
}

void drawLineGraph() {
  fill(128,128,128);
  noStroke();
  rect(0,0,width,height/2); 
}

void drawBarGraph() {
  fill(255,255,255);
  noStroke();
  rect(0,height/2,width,height/2);
  float lineXamt = width/11;
  float lineX = 0;
  stroke(200,200,200);
  for(int i = 0;i<10;i++) {
    lineX = lineX + lineXamt;
    line(lineX,height/2,lineX,height);
  }
  
  float x = 0;
  
  float barWidth = lineXamt;
  for (int i=0;i<11;i++) {
    color c = color(random(255),random(255),random(255));
    float barHeight = random(100,150);
    float y = height - barHeight;
    Bar bar = new Bar(x,y,barWidth,barHeight);
    bar.setBarColor(c);
    bar.display();
    x = x + lineXamt;
  }
}

void loadData() {
  for (int i = 0; i < neurosky.length; i++) {
    String line = neurosky[i];
    if (line.contains("rawEeg")) {
      JSONObject jsonObject = JSONObject.parse(line);
      int rawEeg = jsonObject.getInt("rawEeg");
      rawEegMin = Math.min(rawEegMin, rawEeg);
      rawEegMax = Math.max(rawEegMax, rawEeg);
      rawEegValues.add(rawEeg);
    } else if (line.contains("eSense")) {
      JSONObject eSense = JSONObject.parse(line);
    } else if (line.contains("poorSignalLevel")) {
      JSONObject jsonObject = JSONObject.parse(line);
    }
  }
}
