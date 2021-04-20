
class VoronoiPoint extends Point {
  int r, g, b;
  ArrayList<int[]> points;

  VoronoiPoint(int x, int y) {
    super(x, y);
    r = 0;
    g = 0;
    b = 0;
    points = new ArrayList<int[]>();
  }

  float distTo(int x2, int y2) {
    return dist(x, y, x2, y2);
  }

  void addPoint(int x, int y, color c) {
    points.add(new int[]{x, y});
    r += c >> 16 & 0xFF;
    g += c >> 8 & 0xFF;
    b += c & 0xFF;
  }

  color averageColor() {
    int s = points.size();
    return color(r/s, g/s, b/s);
  }
}



class VoronoiImage {
  PImage img;
  int nPoints;
  ArrayList<VoronoiPoint> vPoints;
  QuadTree qt;

  VoronoiImage(PImage image, int numPoints) {
    img = image;
    nPoints = numPoints;

    // create Voronoi Points
    vPoints = new ArrayList<VoronoiPoint>();
    int x, y;
    for (int i = 0; i < nPoints; i++) {
      x = floor(random(img.width));
      y = floor(random(img.height));
      vPoints.add(new VoronoiPoint(x, y));
    }

    // create quad tree
    Rectangle b = new Rectangle(img.width/2, img.height/2, img.width, img.height);
    qt = new QuadTree(b, 1);
    for (VoronoiPoint vp : vPoints) {
      qt.insert(vp);
    }

    // calculate Voronoi areas
    img.loadPixels();
    ArrayList<Point> eligiblePoints = new ArrayList<Point>();
    float querySize = sqrt(img.width*img.height/nPoints)*5;
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        eligiblePoints = qt.query(new Rectangle(i, j, querySize, querySize), eligiblePoints);

        int closestIndex = 0;
        float distance = 0;
        float closestDistance = img.width*img.height;
        for (int k = 0; k < eligiblePoints.size(); k++) {
          distance = ((VoronoiPoint) eligiblePoints.get(k)).distTo(i, j);
          if (distance < closestDistance) {
            closestDistance = distance;
            closestIndex = k;
          }
        }
        ((VoronoiPoint) eligiblePoints.get(closestIndex)).addPoint(i, j, img.pixels[i+j*img.width]);

        eligiblePoints.clear();
      }
    }
  }

  void export(String filename) {
    PGraphics toExport = createGraphics(img.width, img.height);
    toExport.beginDraw();
    toExport.loadPixels();
    for (VoronoiPoint vp : vPoints) {
      for (int[] p : vp.points) {
        toExport.pixels[p[0]+p[1]*img.width] = vp.averageColor();
      }
    }
    toExport.updatePixels();
    toExport.save(filename);
  }

  void display() {
    loadPixels();
    for (VoronoiPoint vp : vPoints) {
      for (int[] p : vp.points) {
        pixels[p[0]+p[1]*width] = vp.averageColor();
      }
    }
    updatePixels();
  }

  int getWidth() {
    return img.width;
  }

  int getHeight() {
    return img.height;
  }
}
