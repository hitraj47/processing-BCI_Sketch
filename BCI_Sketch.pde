String neurosky[];
int rawEegMin = Integer.MAX_VALUE;
int rawEegMax = Integer.MIN_VALUE;

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
  drawBarGraph();
  drawBarLabels(); 
  drawEegValues();
  drawMouseLine();
}

void drawMouseLine() {
  if (mouseY < height/2) {
    stroke(0, 0, 0);
    line(mouseX, 0, mouseX, height/2);
  }
}

void drawEegValues() {
  for (int i = 0; i < rawEegValues.size(); i++) {
    float x1 = map(i, 0, rawEegValues.size(), 0, width);
    float y1 = map(rawEegValues.get(i), rawEegMin, rawEegMax, 0, height/2);
    y1 = height/2 - y1;
    if ( i + 1 < rawEegValues.size()) {
      i = i+1;
      float x2 = map(i, 0, rawEegValues.size(), 0, width);
      float y2 = map(rawEegValues.get(i), rawEegMin, rawEegMax, 0, height/2);
      y2 = height/2 - y2;
      stroke(RAW_EEG_COLOR);
      line(x1,y1,x2,y2);
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

  float barWidth = lineXamt;
  for (int i=0;i<11;i++) {
    color c = color(random(255), random(255), random(255));
    float barHeight = random(100, 150);
    float y = height - barHeight;
    Bar bar = new Bar(x, y, barWidth, barHeight);
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
    } 
    else if (line.contains("eSense")) {
      JSONObject jsonObject = JSONObject.parse(line);
      JSONObject eSense = jsonObject.getJSONObject("eSense");
      JSONObject eegPower = jsonObject.getJSONObject("eegPower");
      poorSignalLevelValues.add(jsonObject.getInt("poorSignalLevel"));
      attentionValues.add(eSense.getInt("attention"));
      meditationValues.add(eSense.getInt("meditation"));
      deltaValues.add(eegPower.getInt("delta"));
      thetaValues.add(eegPower.getInt("theta"));
      lowAlphaValues.add(eegPower.getInt("lowAlpha"));
      highAlphaValues.add(eegPower.getInt("highAlpha"));
      lowBetaValues.add(eegPower.getInt("lowBeta"));
      highBetaValues.add(eegPower.getInt("highBeta"));
      lowGammaValues.add(eegPower.getInt("lowGamma"));
      highGammaValues.add(eegPower.getInt("highGamma"));
    } 
    else if (line.contains("poorSignalLevel") && !line.contains("eSense") ) {
      JSONObject jsonObject = JSONObject.parse(line);
      poorSignalLevelValues.add(jsonObject.getInt("poorSignalLevel"));
    }
  }
}

