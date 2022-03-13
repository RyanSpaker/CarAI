class Wall {
  ArrayList<Line> lines;
  ArrayList<Line> center;
  float[] distances;
  float totalDistance;
  Wall() {
    lines = new ArrayList<Line>();
    lines.add(new Line(58, 42, 132, 24));
    lines.add(new Line(132, 24, 263, 46));
    lines.add(new Line(263, 46, 293, 90));
    lines.add(new Line(293, 90, 269, 300));
    lines.add(new Line(269, 300, 357, 328));
    lines.add(new Line(357,328,779,318));
    lines.add(new Line(779,318,827,266));
    lines.add(new Line(827,266,752,234));
    lines.add(new Line(752,234,456,221));
    lines.add(new Line(456,221,359,165));
    lines.add(new Line(359,165,347,83));
    lines.add(new Line(347,83,407,23));
    lines.add(new Line(407,23,925,22));
    lines.add(new Line(925,22,1049,81));
    lines.add(new Line(1049,81,1137,163));
    lines.add(new Line(1137,163,1159,227));
    lines.add(new Line(1159,227,1143,269));
    lines.add(new Line(1143,269,1029,339));
    lines.add(new Line(1029,339,1006,396));
    lines.add(new Line(1006,396,1116,538));
    lines.add(new Line(1116,538,1100,624));
    lines.add(new Line(1100,624,1039,669));
    lines.add(new Line(1039,669,633,662));
    lines.add(new Line(633,662,581,615));
    lines.add(new Line(581,615,623,544));
    lines.add(new Line(623,544,700,528));
    lines.add(new Line(700,528,552,480));
    lines.add(new Line(552,480,429,537));
    lines.add(new Line(429,537,411,599));
    lines.add(new Line(411,599,334,633));
    lines.add(new Line(334,633,95,624));
    lines.add(new Line(95,624,36,554));
    lines.add(new Line(36,554,28,108));
    lines.add(new Line(28,108,58,42));
    lines.add(new Line(161,111,183,287));
    lines.add(new Line(183,287,237,386));
    lines.add(new Line(237,386,497,403));
    lines.add(new Line(497,403,818,406));
    lines.add(new Line(818,406,911,335));
    lines.add(new Line(911,335,907,237));
    lines.add(new Line(907,237,825,171));
    lines.add(new Line(825,171,442,107));
    lines.add(new Line(442,107,919,93));
    lines.add(new Line(919,93,1055,223));
    lines.add(new Line(1055,223,918,339));
    lines.add(new Line(918,339,931,412));
    lines.add(new Line(931,412,1012,580));
    lines.add(new Line(1012,580,745,608));
    lines.add(new Line(745,608,749,596));
    lines.add(new Line(749,596,845,556));
    lines.add(new Line(845,556,839,480));
    lines.add(new Line(839,480,714,413));
    lines.add(new Line(714,413,494,411));
    lines.add(new Line(494,411,359,485));
    lines.add(new Line(359,485,132,521));
    lines.add(new Line(132,521,161,111));
    center = new ArrayList<Line>();
    center.add(new Line(88,318,88,102));
    center.add(new Line(88,102,138,71));
    center.add(new Line(138,71,221,89));
    center.add(new Line(221,89,232,302));
    center.add(new Line(232,302,281,354));
    center.add(new Line(281,354,794,354));
    center.add(new Line(794,354,864,287));
    center.add(new Line(864,287,845,230));
    center.add(new Line(845,230,422,151));
    center.add(new Line(422,151,396,116));
    center.add(new Line(396,116,432,54));
    center.add(new Line(432,54,909,54));
    center.add(new Line(909,54,1100,203));
    center.add(new Line(1100,203,1100,249));
    center.add(new Line(1100,249,972,341));
    center.add(new Line(972,341,972,400));
    center.add(new Line(972,400,1062,573));
    center.add(new Line(1062,573,1012,631));
    center.add(new Line(1012,631,669,631));
    center.add(new Line(669,631,669,593));
    center.add(new Line(669,593,765,531));
    center.add(new Line(765,531,765,485));
    center.add(new Line(765,485,564,445));
    center.add(new Line(564,445,404,502));
    center.add(new Line(404,502,266,569));
    center.add(new Line(266,569,119,577));
    center.add(new Line(119,577,88,540));
    center.add(new Line(88,540,88,318));
    distances = new float[28];
    distances[0] = 216.0;
    distances[1] = 58.83026432033091;
    distances[2] = 84.92938243034621;
    distances[3] = 213.283848427395;
    distances[4] = 71.449282711585;
    distances[5] = 513.0;
    distances[6] = 96.89685237405806;
    distances[7] = 60.08327554319921;
    distances[8] = 430.31383895942736;
    distances[9] = 43.60045871318328;
    distances[10] = 71.69379331573968;
    distances[11] = 477.0;
    distances[12] = 242.24367896810023;
    distances[13] = 46.0;
    distances[14] = 157.63248396190426;
    distances[15] = 59.0;
    distances[16] = 195.0102561405425;
    distances[17] = 76.57675887630658;
    distances[18] = 343.0;
    distances[19] = 38.0;
    distances[20] = 114.28035701729323;
    distances[21] = 46.0;
    distances[22] = 204.94145505485218;
    distances[23] = 169.84993376507393;
    distances[24] = 153.40469353966978;
    distances[25] = 147.2175261305528;
    distances[26] = 48.27007354458868;
    distances[27] = 222.0;
    totalDistance = 4600.508213794148;
  }
  public float minimumDistance(PVector A, PVector B, PVector E) { 
    PVector AB = new PVector(); 
    AB.x = B.x - A.x; 
    AB.y = B.y - A.y; 
    PVector BE = new PVector(); 
    BE.x = E.x - B.x; 
    BE.y = E.y - B.y;  
    PVector AE = new PVector(); 
    AE.x = E.x - A.x; 
    AE.y = E.y - A.y; 
    double AB_BE, AB_AE; 
    AB_BE = (AB.x * BE.x + AB.y * BE.y); 
    AB_AE = (AB.x * AE.x + AB.y * AE.y); 
    double reqAns = 0; 
    if (AB_BE > 0){ 
  
        // Finding the magnitude 
        double y12 = E.y - B.y; 
        double x12 = E.x - B.x; 
        reqAns = Math.sqrt(x12 * x12 + y12 * y12); 
    }  else if (AB_AE < 0){ 
        double y12 = E.y - A.y; 
        double x12 = E.x - A.x; 
        reqAns = Math.sqrt(x12 * x12 + y12 * y12); 
    }  else {  
        double x1 = AB.x; 
        double y1 = AB.y; 
        double x2 = AE.x; 
        double y2 = AE.y; 
        double mod = Math.sqrt(x1 * x1 + y1 * y1); 
        reqAns = Math.abs(x1 * y2 - y1 * x2) / mod; 
    } 
    return (float)reqAns; 
  } 
  public PVector closestPoint(PVector ss, PVector se, PVector p){
    return closestPoint(ss.x, ss.y, se.x, se.y, p.x, p.y);
  }
  public PVector closestPoint(float sx1,float sy1,float sx2,float sy2, float px, float py) {
    float xDelta = sx2 - sx1;
    float yDelta = sy2 - sy1;
    if ((xDelta == 0) && (yDelta == 0)){
      return new PVector(sx1, sy1);
    }
    double u = ((px - sx1) * xDelta + (py - sy1) * yDelta) / (xDelta * xDelta + yDelta * yDelta);
    PVector closest;
    if (u < 0){
      closest = new PVector(sx1, sy1);
    }else if (u > 1){
      closest = new PVector(sx2, sy2);
    }else{
      closest = new PVector((int) Math.round(sx1 + u * xDelta), (int) Math.round(sy1 + u * yDelta));
    }
    return closest;
  }
  public int closestLine (Player p){
    PVector carCenter = new PVector(p.pos.x, p.pos.y);
    int closestLine = 0;
    float closestDistance = 10000000000.0;
    for(int i = 0; i < center.size(); i++){
      float howClose = minimumDistance(center.get(i).a, center.get(i).b, carCenter);
      if(howClose<closestDistance){closestLine = i; closestDistance = howClose;}
    }
    return closestLine;
  }
  public float lapDistance (Player p){
    PVector carCenter = new PVector(p.pos.x, p.pos.y);
    int closestLine = 0;
    float closestDistance = 10000000000.0;
    for(int i = 0; i < center.size(); i++){
      float howClose = minimumDistance(center.get(i).a, center.get(i).b, carCenter);
      if(howClose<closestDistance){closestLine = i; closestDistance = howClose;}
    }
    float td = 0;
    for(int i = 0; i < closestLine; i++){
      td += distances[i];
    }
    PVector perpBisector = closestPoint(center.get(closestLine).a, center.get(closestLine).b, carCenter);
    float dist1, dist2;
    dist1 = (float)Math.sqrt((double)(Math.abs(perpBisector.x-center.get(closestLine).a.x)*Math.abs(perpBisector.x-center.get(closestLine).a.x))+(double)(Math.abs(perpBisector.y-center.get(closestLine).a.y)*Math.abs(perpBisector.y-center.get(closestLine).a.y)));
    dist2 = (float)Math.sqrt((double)(Math.abs(perpBisector.x-center.get(closestLine).b.x)*Math.abs(perpBisector.x-center.get(closestLine).b.x))+(double)(Math.abs(perpBisector.y-center.get(closestLine).b.y)*Math.abs(perpBisector.y-center.get(closestLine).b.y)));
    float percentOfLine = dist1/(dist1+dist2);
    percentOfLine *= distances[closestLine];
    td+=percentOfLine;
    td /= totalDistance;
    if (td>=1) td = 0.99999;
    return td;
  }
  public Line checkCollisions(Player p){
    for(Line a: lines){
      if (intersects(a.a, a.b, p.Lfront.a, p.Lfront.b)) return a.clone();
      if (intersects(a.a, a.b, p.Lback.a, p.Lback.b)) return a.clone();
      if (intersects(a.a, a.b, p.Lright.a, p.Lright.b)) return a.clone(); 
      if (intersects(a.a, a.b, p.Lleft.a, p.Lleft.b)) return a.clone();
    }
    return new Line(-1, -1, -1, -1);
  }
  public PVector getIntersect(Line l1, Line l2){
    // Line AB represented as a1x + b1y = c1 
    double a1 = l1.b.y - l1.a.y; 
    double b1 = l1.a.x - l1.b.x; 
    double c1 = a1*(l1.a.x) + b1*(l1.a.y); 
    // Line CD represented as a2x + b2y = c2 
    double a2 = l2.b.y - l2.a.y; 
    double b2 = l2.a.x - l2.b.x; 
    double c2 = a2*(l2.a.x)+ b2*(l2.a.y); 
    double determinant = a1*b2 - a2*b1;  
    double x = (b2*c1 - b1*c2)/determinant; 
    double y = (a1*c2 - a2*c1)/determinant; 
    return new PVector((int)x, (int)y);  
  }
  public float distant(PVector a, PVector b){
    return (float)Math.sqrt((Math.pow(a.x-b.x, 2))+(Math.pow(a.y-b.y, 2)));
  }
  public float getcollisions(Line l){
        ArrayList<PVector> intersects = new ArrayList<PVector>();
        for(Line a: lines){
          if (intersects(a.a, a.b, l.a, l.b)) intersects.add(getIntersect(a, l));
        }
        int si = 0;
        float min = -1;
        for(int i = 0; i < intersects.size(); i++){
          if (distant(l.a, intersects.get(i)) < min || min < 0) {
            min =distant(l.a, intersects.get(i));
            si = i;
          }
        }
        //if(!showNothing && intersects.size()>= si+1)
        //intersects.get(si).Display();
        return min/700;
  }
  public void Display(){
    for(Line a: lines){
      a.Display();
    }
  }
  boolean onSegment(PVector p, PVector q, PVector r) { 
    if (q.x <= max(p.x, r.x) && q.x >= min(p.x, r.x) && q.y <= max(p.y, r.y) && q.y >= min(p.y, r.y)) return true; 
    return false; 
  } 
  int orientation(PVector p, PVector q, PVector r) { 
    float val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y); 
    if (val == 0) return 0;  // colinear 
    return (val > 0)? 1: 2; // clock or counterclock wise 
  } 
  boolean intersects(PVector p1, PVector q1, PVector p2, PVector q2) { 
    // Find the four orientations needed for general and 
    // special cases 
    int o1 = orientation(p1, q1, p2); 
    int o2 = orientation(p1, q1, q2); 
    int o3 = orientation(p2, q2, p1); 
    int o4 = orientation(p2, q2, q1); 
  
    // General case 
    if (o1 != o2 && o3 != o4) return true; 
  
    // Special Cases 
    // p1, q1 and p2 are colinear and p2 lies on segment p1q1 
    if (o1 == 0 && onSegment(p1, p2, q1)) return true; 
  
    // p1, q1 and q2 are colinear and q2 lies on segment p1q1 
    if (o2 == 0 && onSegment(p1, q2, q1)) return true; 
  
    // p2, q2 and p1 are colinear and p1 lies on segment p2q2 
    if (o3 == 0 && onSegment(p2, p1, q2)) return true; 
  
     // p2, q2 and q1 are colinear and q1 lies on segment p2q2 
    if (o4 == 0 && onSegment(p2, q1, q2)) return true; 
  
    return false; // Doesn't fall in any of the above cases 
  }  //<>//
}
