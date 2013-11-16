class Bar {

  private float barWidth, barHeight;
  private float x, y;
  private color barColor;
  private color strokeColor;
  private boolean stroke;

  public Bar(float _x, float _y, float _barWidth, float _barHeight) {

    this.x = _x;
    this.y = _y;
    this.barWidth = _barWidth;
    this.barHeight = _barHeight;
    this.stroke = false;
  }

  public void setBarColor(color _barColor) {
    this.barColor = _barColor;
  }

  public color getBarColor() {
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

  public void setStrokeColor(color strokeColor) {
    this.strokeColor = strokeColor;
  }

  public color getStrokeColor() {
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

