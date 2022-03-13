class Line {
  PVector a, b;
  boolean deadly = true;
  boolean checkpoint = false;
  int strokeStr = 10;
  int seq;
  Line(int x,int y,int i,int j, boolean aa, boolean ba, int seq) {
    a = new PVector(x, y);
    b = new PVector(i, j);
    deadly = aa;
    checkpoint = ba;
    this.seq = seq;
  }
  Line(int x,int y,int i,int j, boolean aa, boolean ba) {
    a = new PVector(x, y);
    b = new PVector(i, j);
    deadly = aa;
    checkpoint = ba;
  }
  Line(int x,int y,int i,int j) {
    a = new PVector(x, y);
    b = new PVector(i, j);
  }
  Line(PVector aa, PVector bb) {
    a = new PVector(aa.x, aa.y);
    b = new PVector(bb.x, bb.y);
  }
  public void Display(){
    stroke(strokeStr);
    line(a.x, a.y, b.x, b.y);
    stroke(204, 102, 0);
    fill(204, 102, 0);
    ellipse(a.x, a.y, 4, 4);
    ellipse(b.x, b.y, 4, 4);
  }
  public Line clone(){
    return new Line(a, b);
  }
}
