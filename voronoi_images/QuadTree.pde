/*
 * Point Class
 */

class Point {
  float x, y;
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void show() {
    strokeWeight(2);
    stroke(255);
    point(this.x, this.y);
  }
}


/*
 * Rectangle Class
 */

class Rectangle {
  float x, y, w, h;
  Rectangle(float x, float y, float w, float h) {
    this.x = x;   
    this.y = y;   
    this.w = w;   
    this.h = h;
  }

  boolean contains(Point p) {
    return (p.x >= this.x-this.w/2 
      && p.x <= this.x+this.w/2 
      && p.y >= this.y-this.h/2 
      && p.y <= this.y+this.h/2);
  }

  boolean intersects(Rectangle range) {
    //keep in mind, it's on RectMode(CENTER)

    // range is on right side of this
    if (range.x-range.w/2 > this.x+this.w/2)
      return false;

    // range is on left side of this
    if (range.x+range.w/2 < this.x-this.w/2)
      return false;

    // range is on top side of this
    if (range.y+range.h/2 < this.y-this.h/2)
      return false;

    // range is on bottom side of this
    if (range.y-range.h/2 > this.y+this.h/2)
      return false;

    // all other cases are intersecting
    return true;
  }
  
  void show() {
    //noFill();
    //strokeWeight(1);
    //stroke(255);
    //rect(this.x, this.y, this.w, this.h);
  }
}


/*
 * Quad Tree
 */

class QuadTree {
  Rectangle boundary;
  int capacity;
  ArrayList<Point> points;

  QuadTree northeast;
  QuadTree northwest;
  QuadTree southeast;
  QuadTree southwest;
  boolean divided = false;

  QuadTree(Rectangle b, int c) {
    this.boundary = b; 
    this.capacity= c;
    this.points = new ArrayList<Point>();
  }

  void insert(Point p) {

    if (this.points.size() < this.capacity) {
      this.points.add(p);
    } else {
      if (!this.divided) {
        this.subdivide();
      }

      //finding the correct sub quadtree to put the point in and then putting it there.
      if (this.northeast.boundary.contains(p)) {
        this.northeast.insert(p);
        //this.points.remove(p);
      } else if (this.northwest.boundary.contains(p)) {
        this.northwest.insert(p);
        //this.points.remove(p);
      } else if (this.southeast.boundary.contains(p)) {
        this.southeast.insert(p);
        //this.points.remove(p);
      } else if (this.southwest.boundary.contains(p)) {
        this.southwest.insert(p);
        //this.points.remove(p);
      }
    }
  }

  void subdivide() {
    Rectangle ne = new Rectangle(this.boundary.x+this.boundary.w/4, this.boundary.y-this.boundary.h/4, this.boundary.w/2, this.boundary.h/2);
    this.northeast = new QuadTree(ne, this.capacity);
    Rectangle nw = new Rectangle(this.boundary.x-this.boundary.w/4, this.boundary.y-this.boundary.h/4, this.boundary.w/2, this.boundary.h/2);
    this.northwest = new QuadTree(nw, this.capacity);
    Rectangle se = new Rectangle(this.boundary.x+this.boundary.w/4, this.boundary.y+this.boundary.h/4, this.boundary.w/2, this.boundary.h/2);
    this.southeast = new QuadTree(se, this.capacity);
    Rectangle sw = new Rectangle(this.boundary.x-this.boundary.w/4, this.boundary.y+this.boundary.h/4, this.boundary.w/2, this.boundary.h/2);
    this.southwest = new QuadTree(sw, this.capacity);

    this.divided = true;
  }

  ArrayList<Point> query(Rectangle range, ArrayList<Point> found) {

    //base case
    if (!this.boundary.intersects(range)) {
      return found;
    }

    for (Point p : this.points) {
      if (range.contains(p)) {
        found.add(p);
      }
    }

    //other base case
    if (this.divided) {
      this.northeast.query(range, found);
      this.northwest.query(range, found);
      this.southeast.query(range, found);
      this.southwest.query(range, found);
    }
    
    return found;
  }

  void show() {
    for (Point p : this.points) {
      p.show();
    }
    this.boundary.show();

    if (this.divided) {
      this.northeast.show();
      this.northwest.show();
      this.southeast.show();
      this.southwest.show();
    }
  }
}
