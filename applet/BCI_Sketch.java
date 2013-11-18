import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Collections; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BCI_Sketch extends PApplet {



String neurosky[];

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

public final int ATTENTION_COLOR = color(96, 96, 96);
public final int MEDITATION_COLOR = color(255, 69, 0);
public final int DELTA_COLOR = color(255, 255, 0);
public final int THETA_COLOR = color(255, 0, 0);
public final int LOW_ALPHA_COLOR = color(255, 20, 147);
public final int HIGH_ALPHA_COLOR = color(208, 32, 144);
public final int LOW_BETA_COLOR = color(186, 85, 211);
public final int HIGH_BETA_COLOR = color(160, 32, 240);
public final int LOW_GAMMA_COLOR = color(0, 191, 255);
public final int HIGH_GAMMA_COLOR = color(25, 25, 112);
public final int RAW_EEG_COLOR = color(46, 139, 87); 

public void setup() {
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

public void draw() {
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
  if (mouseY <= height/2) {
    drawBarsForData(mouseX);
    drawSignalQuality(mouseX);
  }
  drawBarLabels(); 
  drawMouseLine();
}

public void drawSignalQuality(int _x) {
  // draw box
  int w = 120;
  int h = 40;
  noStroke();
  fill(255,255,255);
  rect(width-w-10,10,w,h);
  
  // text
  fill(0,0,0);
  text("Signal", width-w,25);
  text("Quality", width-w,45);
  
  // circle thingy
  noFill();
  strokeWeight(1);
  stroke(0, 0, 0);
  int d = 30;
  
  int index = (int) map(_x,0, width, 0, poorSignalLevelValues.size());
  int max = Collections.max(poorSignalLevelValues);
  int min = Collections.min(poorSignalLevelValues);
  int signalLevel = max - poorSignalLevelValues.get(index);
  if (signalLevel > 25) {
    fill(0,255,0);
  } else {
    fill(255,0,0);
  }
  ellipse(width-35,30,d,d);
}

public void drawMouseLine() {
  if (mouseY < height/2) {
    stroke(0, 0, 0);
    line(mouseX, 0, mouseX, height/2);
  }
}

public void drawLineOnGraph(ArrayList<Integer> values, int lineColor) {

  float prevx = 0;
  float prevy = 0;
  float min = Collections.min(values);
  float max = Collections.max(values);
  for (int i=0; i < values.size(); i++) {
    float x1;
    // check to see if last value, if so, add 1 to i so it displays
    // at the end of the graph
    if (i+1 == values.size()) {
      x1 = map(i+1, 0, values.size(), 0, width);
    } 
    else {
      x1 = map(i, 0, values.size(), 0, width);
    }
    float y1 = map(values.get(i), min, max, 0, height/2);
    y1 = height/2 - y1;

    // make sure to connect the previous point with the new point
    if (i > 0) {
      stroke(lineColor);
      strokeWeight(1);
      line(prevx, prevy, x1, y1);
    }
    if (i+1 < values.size()) {
      i = i+1;
      float x2 = map(i, 0, values.size(), 0, width);
      float y2 = map(values.get(i), min, max, 0, height/2);
      y2 = height/2 - y2;
      stroke(lineColor);
      strokeWeight(1);
      line(x1,y1,x2,y2);
      prevx = x2;
      prevy = y2;
    }
  }
}

private String getValueLabel(ArrayList<Integer> list) {
      int index = (int) map(mouseX, 0, width, 0, list.size());
      int value = list.get(index);
      int max = Collections.max(list);
      int min = Collections.min(list);
      return min + " - " + max + "\n" + value; 
}

public void drawBarLabels() {
  ArrayList<String> barLabels = new ArrayList<String>();
  
  String attention = "Attention\n";
  if (mouseY<=height/2) {
      attention = attention + getValueLabel(attentionValues); 
  }
  barLabels.add(attention);
  
  String meditation = "Meditation\n";
  if (mouseY<=height/2) {
      meditation = meditation + getValueLabel(meditationValues); 
  }
  barLabels.add(meditation);
  
  String delta = "Delta\n";
  if (mouseY<=height/2) {
      delta = delta + getValueLabel(deltaValues); 
  }
  barLabels.add(delta);
  
  String theta = "Theta\n";
  if (mouseY<=height/2) {
      theta = theta + getValueLabel(thetaValues); 
  }
  barLabels.add(theta);
  
  String lowAlpha = "Low Alpha\n";
  if (mouseY<=height/2) {
      lowAlpha = lowAlpha + getValueLabel(lowAlphaValues); 
  }  
  barLabels.add(lowAlpha);
  
  String highAlpha = "High Alpha\n";
  if (mouseY<=height/2) {
      highAlpha = highAlpha + getValueLabel(highAlphaValues); 
  }
  barLabels.add(highAlpha);
  
  String lowBeta = "Low Beta\n";
  if (mouseY<=height/2) {
      lowBeta = lowBeta + getValueLabel(lowBetaValues); 
  }
  barLabels.add(lowBeta);
  
  String highBeta = "High Beta\n";
  if (mouseY<=height/2) {
      highBeta = highBeta + getValueLabel(highBetaValues); 
  }
  barLabels.add(highBeta);
  
  String lowGamma = "Low Gamma\n";
  if (mouseY<=height/2) {
      lowGamma = lowGamma + getValueLabel(lowGammaValues); 
  }
  barLabels.add(lowGamma);
  
  String highGamma = "High Gamma\n";
  if (mouseY<=height/2) {
      highGamma = highGamma + getValueLabel(highGammaValues); 
  }
  barLabels.add(highGamma);

  String rawEeg = "Raw EEG\n";
  if (mouseY<=height/2) {
      rawEeg = rawEeg + getValueLabel(rawEegValues); 
  }
  barLabels.add(rawEeg);

  float widthApart = width/11;
  float lineX = 0;
  for (int i=0; i<barLabels.size(); i++) {
    fill(0);
    String label = barLabels.get(i);
    float textWidth = textWidth(label);
    int y = height/2 + 15;
    float x = ( (lineX + widthApart)-(lineX + textWidth) )/2 + lineX;
    text(label, x, y);
    
    lineX = lineX + widthApart;
  }
}

public void drawLineGraph() {
  fill(128, 128, 128);
  noStroke();
  rect(0, 0, width, height/2);
}

public void drawBarGraph() {
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
}

public void drawBarsForData(int _x) {
  float barWidth = width/11;
  float x = 0;
  int index = 0;
  float barHeight = 0;
  float y = 0;

  // draw attention bar
  index = (int) map(_x, 0, width, 0, attentionValues.size());
  int attention = attentionValues.get(index);
  barHeight = map(attention, Collections.min(attentionValues), Collections.max(attentionValues), 0, height/2);
  y = height - barHeight;
  Bar attentionBar = new Bar(x, y, barWidth, barHeight);  
  attentionBar.setBarColor(ATTENTION_COLOR);
  if (attention > 60) {
    attentionBar.setStroke(true);
    attentionBar.setStrokeColor(color(255,0,0));
  } else {
    attentionBar.setStroke(false); 
  }
  attentionBar.display();
  x = x + barWidth;

  // meditation bar
  index = (int) map(_x, 0, width, 0, meditationValues.size());
  int meditation = meditationValues.get(index);
  barHeight = map(meditation, Collections.min(meditationValues), Collections.max(meditationValues), 0, height/2);
  y = height - barHeight;
  Bar meditationBar = new Bar(x, y, barWidth, barHeight);
  meditationBar.setBarColor(MEDITATION_COLOR);
  if (meditation > 60) {
    meditationBar.setStroke(true);
    meditationBar.setStrokeColor(color(0,0,255));
  } else {
    meditationBar.setStroke(false);
  }
  meditationBar.display();
  x = x + barWidth;

  // delta
  index = (int) map(_x, 0, width, 0, deltaValues.size());
  int delta = deltaValues.get(index);
  barHeight = map(delta, Collections.min(deltaValues), Collections.max(deltaValues), 0, height/2);
  y = height - barHeight;
  Bar deltaBar = new Bar(x, y, barWidth, barHeight);
  deltaBar.setBarColor(DELTA_COLOR);
  deltaBar.display();
  x = x + barWidth;

  // theta
  index = (int) map(_x, 0, width, 0, thetaValues.size());
  int theta = thetaValues.get(index);
  barHeight = map(theta, Collections.min(thetaValues), Collections.max(thetaValues), 0, height/2);
  y = height - barHeight;
  Bar thetaBar = new Bar(x, y, barWidth, barHeight);
  thetaBar.setBarColor(THETA_COLOR);
  thetaBar.display();
  x = x + barWidth;

  // low alpha
  index = (int) map(_x, 0, width, 0, lowAlphaValues.size());
  int lowAlpha = lowAlphaValues.get(index);
  barHeight = map(lowAlpha, Collections.min(lowAlphaValues), Collections.max(lowAlphaValues), 0, height/2);
  y = height - barHeight;
  Bar lowAlphaBar = new Bar(x, y, barWidth, barHeight);
  lowAlphaBar.setBarColor(LOW_ALPHA_COLOR);
  lowAlphaBar.display();
  x = x + barWidth;

  // high alpha
  index = (int) map(_x, 0, width, 0, highAlphaValues.size());
  int highAlpha = highAlphaValues.get(index);
  barHeight = map(highAlpha, Collections.min(highAlphaValues), Collections.max(highAlphaValues), 0, height/2);
  y = height - barHeight;
  Bar highAlphaBar = new Bar(x, y, barWidth, barHeight);
  highAlphaBar.setBarColor(HIGH_ALPHA_COLOR);
  highAlphaBar.display();
  x = x + barWidth;

  // low beta
  index = (int) map(_x, 0, width, 0, lowBetaValues.size());
  int lowBeta = lowBetaValues.get(index);
  barHeight = map(lowBeta, Collections.min(lowBetaValues), Collections.max(lowBetaValues), 0, height/2);
  y = height - barHeight;
  Bar lowBetaBar = new Bar(x, y, barWidth, barHeight);
  lowBetaBar.setBarColor(LOW_BETA_COLOR);
  lowBetaBar.display();
  x = x + barWidth;

  // high beta
  index = (int) map(_x, 0, width, 0, highBetaValues.size());
  int highBeta = highBetaValues.get(index);
  barHeight = map(highBeta, Collections.min(highBetaValues), Collections.max(highBetaValues), 0, height/2);
  y = height - barHeight;
  Bar highBetaBar = new Bar(x, y, barWidth, barHeight);
  highBetaBar.setBarColor(HIGH_BETA_COLOR);
  highBetaBar.display();
  x = x + barWidth;

  // low gamma
  index = (int) map(_x, 0, width, 0, lowGammaValues.size());
  int lowGamma = lowGammaValues.get(index);
  barHeight = map(lowGamma, Collections.min(lowGammaValues), Collections.max(lowGammaValues), 0, height/2);
  y = height - barHeight;
  Bar lowGammaBar = new Bar(x, y, barWidth, barHeight);
  lowGammaBar.setBarColor(LOW_GAMMA_COLOR);
  lowGammaBar.display();
  x = x + barWidth;

  // high gamma
  index = (int) map(_x, 0, width, 0, highGammaValues.size());
  int highGamma = highGammaValues.get(index);
  barHeight = map(highGamma, Collections.min(highGammaValues), Collections.max(highGammaValues), 0, height/2);
  y = height - barHeight;
  Bar highGammaBar = new Bar(x, y, barWidth, barHeight);
  highGammaBar.setBarColor(HIGH_GAMMA_COLOR);
  highGammaBar.display();
  x = x + barWidth;

  // raw eeg
  index = (int) map(_x, 0, width, 0, rawEegValues.size());
  int rawEeg = rawEegValues.get(index);
  barHeight = map(rawEeg, Collections.min(rawEegValues), Collections.max(rawEegValues), 0, height/2);
  y = height - barHeight;
  Bar rawEegBar = new Bar(x, y, barWidth, barHeight);
  rawEegBar.setBarColor(RAW_EEG_COLOR);
  rawEegBar.display();
}

public void loadData() {
  for (int i = 0; i < neurosky.length; i++) {
    String line = neurosky[i];
    if (line.contains("rawEeg")) {
      JSONObject jsonObject = JSONObject.parse(line);
      int rawEeg = jsonObject.getInt("rawEeg");
      rawEegValues.add(rawEeg);
    } 
    else if (line.contains("eSense")) {
      JSONObject jsonObject = JSONObject.parse(line);
      JSONObject eSense = jsonObject.getJSONObject("eSense");
      JSONObject eegPower = jsonObject.getJSONObject("eegPower");

      int poorSignalLevel = jsonObject.getInt("poorSignalLevel");
      poorSignalLevelValues.add(poorSignalLevel);

      int attention = eSense.getInt("attention");
      attentionValues.add(attention);

      int meditation = eSense.getInt("meditation");
      meditationValues.add(meditation);

      int delta = eegPower.getInt("delta");
      deltaValues.add(delta);

      int theta = eegPower.getInt("theta");
      thetaValues.add(theta);

      int lowAlpha = eegPower.getInt("lowAlpha");
      lowAlphaValues.add(lowAlpha);

      int highAlpha = eegPower.getInt("highAlpha");
      highAlphaValues.add(highAlpha);

      int lowBeta = eegPower.getInt("lowBeta");
      lowBetaValues.add(lowBeta);

      int highBeta = eegPower.getInt("highBeta");
      highBetaValues.add(highBeta);

      int lowGamma = eegPower.getInt("lowGamma");
      lowGammaValues.add(lowGamma);

      int highGamma = eegPower.getInt("highGamma");
      highGammaValues.add(highGamma);
    } 
    else if (line.contains("poorSignalLevel") && !line.contains("eSense") ) {
      JSONObject jsonObject = JSONObject.parse(line);
      int poorSignalLevel = jsonObject.getInt("poorSignalLevel");
      poorSignalLevelValues.add(poorSignalLevel);
    }
  }
}

class Bar {

  private float barWidth, barHeight;
  private float x, y;
  private int barColor;
  private int strokeColor;
  private boolean stroke;

  public Bar(float _x, float _y, float _barWidth, float _barHeight) {

    this.x = _x;
    this.y = _y;
    this.barWidth = _barWidth;
    this.barHeight = _barHeight;
    this.stroke = false;
  }

  public void setBarColor(int _barColor) {
    this.barColor = _barColor;
  }

  public int getBarColor() {
    return barColor;
  }

  public void setBarWidth(float _barWidth) {
    this.barWidth = _barWidth;
  }

  public float getBarWidth() {
    return barWidth;
  }

  public void setBarHeight(float _barHeight) {
    this.barHeight = _barHeight;
  }

  public float getBarHeight() {
    return barHeight;
  }

  public void setX(float _x) {
    this.x = _x;
  }

  public float getX() {
    return x;
  }

  public void setY(float _y) {
    this.y = _y;
  }

  public float getY() {
    return y;
  }

  public void setStroke(boolean tof) {
    this.stroke = tof;
  }

  public boolean isStroke() {
    return this.stroke;
  }

  public void setStrokeColor(int strokeColor) {
    this.strokeColor = strokeColor;
  }

  public int getStrokeColor() {
    return this.strokeColor;
  }

  public void display() {
    fill(barColor);
    if (stroke == false) {
      noStroke();
    } 
    else {
      strokeWeight(3);
      stroke(strokeColor);
    }
    rect(x, y, barWidth, barHeight);
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BCI_Sketch" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
