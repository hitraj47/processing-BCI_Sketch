String neurosky[];
int graphMax = Integer.MIN_VALUE;
int graphMin = Integer.MAX_VALUE;

ArrayList<Integer> attentionValues;
ArrayList<Integer> meditationValues;
ArrayList<Integer> poorSignalLevelValues;
ArrayList<Integer> deltaValues;
ArrayList<Integer> thetaValues;
ArrayList<Integer> lowAlphaValues;
ArrayList<Integer> highAlphaValues;
ArrayList<Integer> lowBetaValues;
ArrayList<Integer> highBetaValues;
ArrayList<Integer> lowGammaValues;
ArrayList<Integer> highGammaValues;
ArrayList<Integer> rawEegValues;

public final color ATTENTION_COLOR = color(96,96,96);
public final color MEDITATION_COLOR = color(0,0,0);
public final color DELTA_COLOR = color(255,255,0);
public final color THETA_COLOR = color(255,0,0);
public final color LOW_ALPHA_COLOR = color(255,20,147);
public final color HIGH_ALPHA_COLOR = color(208,32,144);
public final color LOW_BETA_COLOR = color(186,85,211);
public final color HIGH_BETA_COLOR = color(160,32,240);
public final color LOW_GAMMA_COLOR = color(0,191,255);
public final color HIGH_GAMMA_COLOR = color(25,25,112);
public final color RAW_EEG_COLOR = color(46,139,87); 

void setup() {
  size(1100, 700);
  
  neurosky = loadStrings("neurosky.json");
  attentionValues = new ArrayList<Integer>();
  meditationValues = new ArrayList<Integer>();
  poorSignalLevelValues = new ArrayList<Integer>();
  deltaValues = new ArrayList<Integer>();
  thetaValues = new ArrayList<Integer>();
  lowAlphaValues = new ArrayList<Integer>();
  highAlphaValues = new ArrayList<Integer>();
  lowBetaValues = new ArrayList<Integer>();
  highBetaValues = new ArrayList<Integer>();
  lowGammaValues = new ArrayList<Integer>();
  highGammaValues = new ArrayList<Integer>();
  rawEegValues = new ArrayList<Integer>();
  loadData();
}

void draw() {
  drawLineGraph();
  drawLineOnGraph(attentionValues, ATTENTION_COLOR);
  drawLineOnGraph(meditationValues, MEDITATION_COLOR);
  drawLineOnGraph(deltaValues, DELTA_COLOR);
  drawLineOnGraph(thetaValues, THETA_COLOR);
  drawLineOnGraph(lowAlphaValues, LOW_ALPHA_COLOR);
  drawLineOnGraph(highAlphaValues, HIGH_ALPHA_COLOR);
  drawLineOnGraph(lowBetaValues, LOW_BETA_COLOR);
  drawLineOnGraph(highBetaValues, HIGH_BETA_COLOR);
  drawLineOnGraph(lowGammaValues, LOW_GAMMA_COLOR);
  drawLineOnGraph(highGammaValues, HIGH_GAMMA_COLOR);
  drawLineOnGraph(rawEegValues, RAW_EEG_COLOR);
  drawBarGraph();
  //drawBarsForData(mouseX);
  drawBarLabels(); 
  drawMouseLine();
}

void drawMouseLine() {
  if (mouseY < height/2) {
    stroke(0, 0, 0);
    line(mouseX, 0, mouseX, height/2);
  }
}

void drawLineOnGraph(ArrayList<Integer> values, color lineColor) {
  
  float prevx = 0;
  float prevy = 0;
  for(int i=0; i < values.size(); i++) {
    float x1;
    // check to see if last value, if so, add 1 to i so it displays
    // at the end of the graph
    if (i+1 == values.size()) {
      x1 = map(i+1, 0, values.size(), 0, width);
    } else {
      x1 = map(i, 0, values.size(), 0, width);
    }
    float y1 = map(values.get(i), graphMin, graphMax, 0, height/2);
    y1 = height/2 - y1;
    
    // make sure to connect the previous point with the new point
    if (i > 0) {
      stroke(lineColor);
      line(prevx,prevy,x1,y1);
    }
    if (i+1 < values.size()) {
      i = i+1;
      float x2 = map(i, 0, values.size(), 0, width);
      float y2 = map(values.get(i), graphMin, graphMax, 0, height/2);
      y2 = height/2 - y2;
      stroke(lineColor);
      line(x1,y1,x2,y2);
      prevx = x2;
      prevy = y2;
    }
  }
    
}

void drawBarLabels() {
  ArrayList<String> barLabels = new ArrayList<String>();
  barLabels.add("Attention");
  barLabels.add("Meditation");
  barLabels.add("Delta");
  barLabels.add("Theta");
  barLabels.add("Low Alpha");
  barLabels.add("High Alpha");
  barLabels.add("Low Beta");
  barLabels.add("High Beta");
  barLabels.add("Low Gamma");
  barLabels.add("High Gamma");
  barLabels.add("Raw EEG");
  float widthApart = width/11;
  float lineX = 0;
  for (int i=0; i<barLabels.size(); i++){
      fill(0);
      String label = barLabels.get(i);
      float textWidth = textWidth(label);
      int y = height/2 + 15;
      float x = ( (lineX + widthApart)-(lineX + textWidth) )/2 + lineX;
      text(label, x, y);
      lineX = lineX + widthApart;
  }
  
}

void drawLineGraph() {
  fill(128, 128, 128);
  noStroke();
  rect(0, 0, width, height/2);
}

void drawBarGraph() {
  fill(255, 255, 255);
  noStroke();
  rect(0, height/2, width, height/2);
  float lineXamt = width/11;
  float lineX = 0;
  stroke(200, 200, 200);
  for (int i = 0;i<10;i++) {
    lineX = lineX + lineXamt;
    line(lineX, height/2, lineX, height);
  }

  float x = 0;

  /*
  float barWidth = lineXamt;
  for (int i=0;i<11;i++) {
    color c = color(random(255), random(255), random(255));
    float barHeight = 300;
    float y = height - barHeight;
    Bar bar = new Bar(x, y, barWidth, barHeight);
    bar.setBarColor(c);
    bar.display();
    x = x + lineXamt;
  }
  */
}

void drawBarsForData(int _x) {
  float barWidth = width/11;
  float x = 0;
  int index = 0;
  float barHeight = 0;
  float y = 0;
  
  // draw attention bar
  index = (int) map(_x, 0, width, 0, attentionValues.size());
  int attention = attentionValues.get(index);
  barHeight = map(attention, graphMin, graphMax, 0, height/2);
  y = height - barHeight;
  Bar attentionBar = new Bar(x, y, barWidth, barHeight);
  attentionBar.setBarColor(ATTENTION_COLOR);
  attentionBar.display();
  x = x + barWidth;
  
  // meditation bar
  index = (int) map(_x, 0, width, 0, meditationValues.size());
  int meditation = meditationValues.get(index);
  barHeight = map(meditation, graphMin, graphMax, 0, height/2);
  y = height - barHeight;
  Bar meditationBar = new Bar(x, y, barWidth, barHeight);
  meditationBar.setBarColor(MEDITATION_COLOR);
  meditationBar.display();
  x = x + barWidth;
  
  // delta
  index = (int) map(_x, 0, width, 0, deltaValues.size());
  int delta = deltaValues.get(index);
  barHeight = map(meditation, graphMin, graphMax, 0, height/2);
  y = height - barHeight;
  Bar deltaBar = new Bar(x, y, barWidth, barHeight);
  deltaBar.setBarColor(DELTA_COLOR);
  deltaBar.display();
  x = x + barWidth;
}

void loadData() {
  for (int i = 0; i < neurosky.length; i++) {
    String line = neurosky[i];
    if (line.contains("rawEeg")) {
      JSONObject jsonObject = JSONObject.parse(line);
      int rawEeg = jsonObject.getInt("rawEeg");
      graphMin = Math.min(graphMin, rawEeg);
      graphMax = Math.max(graphMax, rawEeg);
      rawEegValues.add(rawEeg);
    } else if (line.contains("eSense")) {
      JSONObject jsonObject = JSONObject.parse(line);
      JSONObject eSense = jsonObject.getJSONObject("eSense");
      JSONObject eegPower = jsonObject.getJSONObject("eegPower");
      
      int poorSignalLevel = jsonObject.getInt("poorSignalLevel");
      poorSignalLevelValues.add(poorSignalLevel);
      graphMin = Math.min(graphMin, poorSignalLevel);
      graphMax = Math.max(graphMax, poorSignalLevel);
      
      int attention = eSense.getInt("attention");
      attentionValues.add(attention);
      graphMin = Math.min(graphMin, attention);
      graphMax = Math.max(graphMax, attention);
      
      int meditation = eSense.getInt("meditation");
      meditationValues.add(meditation);
      graphMin = Math.min(graphMin, meditation);
      graphMax = Math.max(graphMax, meditation);
      
      int delta = eegPower.getInt("delta");
      deltaValues.add(delta);
      graphMin = Math.min(graphMin, delta);
      graphMax = Math.max(graphMax, delta);
      
      int theta = eegPower.getInt("theta");
      thetaValues.add(theta);
      graphMin = Math.min(graphMin, theta);
      graphMax = Math.max(graphMax, theta);
      
      int lowAlpha = eegPower.getInt("lowAlpha");
      lowAlphaValues.add(lowAlpha);
      graphMin = Math.min(graphMin, lowAlpha);
      graphMax = Math.max(graphMax, lowAlpha);
      
      int highAlpha = eegPower.getInt("highAlpha");
      highAlphaValues.add(highAlpha);
      graphMin = Math.min(graphMin, highAlpha);
      graphMax = Math.max(graphMax, highAlpha);
      
      int lowBeta = eegPower.getInt("lowBeta");
      lowBetaValues.add(lowBeta);
      graphMin = Math.min(graphMin, lowBeta);
      graphMax = Math.max(graphMax, lowBeta);
      
      int highBeta = eegPower.getInt("highBeta");
      highBetaValues.add(highBeta);
      graphMin = Math.min(graphMin, highBeta);
      graphMax = Math.max(graphMax, highBeta);
      
      int lowGamma = eegPower.getInt("lowGamma");
      lowGammaValues.add(lowGamma);
      graphMin = Math.min(graphMin, lowGamma);
      graphMax = Math.max(graphMax, lowGamma);
      
      int highGamma = eegPower.getInt("highGamma");
      highGammaValues.add(highGamma);
      graphMin = Math.min(graphMin, highGamma);
      graphMax = Math.max(graphMax, highGamma);
      
    } 
    else if (line.contains("poorSignalLevel") && !line.contains("eSense") ) {
      JSONObject jsonObject = JSONObject.parse(line);
      int poorSignalLevel = jsonObject.getInt("poorSignalLevel");
      poorSignalLevelValues.add(poorSignalLevel);
      graphMin = Math.min(graphMin, poorSignalLevel);
      graphMax = Math.max(graphMax, poorSignalLevel);
    }
  }
}

