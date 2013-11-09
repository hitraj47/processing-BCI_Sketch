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

