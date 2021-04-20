 //<>//
VoronoiImage vImage;
int nVPoints = 25000;
PImage img;
String imgName = "appa.jpg";
boolean keep = true;
boolean export;

// good sizes: 15, 25, 50, 100, 175, 250, 500, 1000, 2000, 5000, 10000, 50000, 100000
int[] goodSizes = new int[]{15, 25, 50, 100, 175, 250, 500, 1000, 2000, 5000, 10000, 25000, 50000, 100000};

void setup() {
  surface.setResizable(true);

  img = loadImage(imgName);

  if (img.width > displayWidth || img.height > displayHeight) {
    export = true;
  } else {
    export = false;
    surface.setSize(img.width, img.height);
  }
}

// loops through sizes
int sizeIndex = 0;
void draw() {
  vImage = new VoronoiImage(img, goodSizes[sizeIndex]);

  if (export) {
    vImage.export("prints/"+split(imgName, ".")[0]+"/v_Big_"+goodSizes[sizeIndex]+"_"+imgName);
  } else {
    vImage.display();
    if (keep) {
      save("prints/"+split(imgName, ".")[0]+"/v_"+goodSizes[sizeIndex]+"_"+imgName);
    }
  }

  sizeIndex++;
  if (sizeIndex == goodSizes.length) {
    noLoop();
    exit();
  }
}

// single size
//void draw() {

//  vImage = new VoronoiImage(img, nVPoints);

//  if (export) {
//    vImage.export("prints/"+split(imgName, ".")[0]+"/v_Big_"+nVPoints+"_"+imgName);
//    exit();
//  } else {
//    vImage.display();

//    if (keep) {
//      save("prints/"+split(imgName, ".")[0]+"/v_"+nVPoints+"_"+imgName);
//    }
//  }
//  noLoop();
//}
