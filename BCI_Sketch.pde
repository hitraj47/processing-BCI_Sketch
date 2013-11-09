String neurosky[];

void setup() {
  size(1100,700);
  neurosky = loadStrings("neurosky.json");
  loadData();
}

void draw() {
  drawLineGraph();
  drawBarGraph(); 
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
      //println(jsonObject.getInt("rawEeg"));
    } else if (line.contains("eSense")) {
      JSONObject eSense = JSONObject.parse(line);
    } else if (line.contains("poorSignalLevel")) {
      JSONObject jsonObject = JSONObject.parse(line);
    }
  }
}
