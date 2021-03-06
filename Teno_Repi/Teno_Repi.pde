import processing.video.*;
import gab.opencv.*;
import java.util.ArrayList;

Capture video;
OpenCV opcv;
PImage recipe;

void setup() {
  recipe = loadImage("sample.png");

  size(640, 480);
  video = new Capture(this, width, height);
  opcv = new OpenCV(this, width, height);

  video.start();
  loadPixels(); //windowのピクセルにpixels[]で参照できる
}

void draw() {
  // background(0);
  if(video.available()){
    video.read();
    video.loadPixels(); //captureしたカメラ画像のピクセルを取得
    image(video, 0, 0);

    colorMode(HSB);
    filter(BLUR); //パラメータ無しでガウシアンフィルタ
    //明度で2値化
    toFleshColorBinarizationIm();
    //video.filter(DILATE); //膨張処理
    distTransform();
    findHandContour();
    updatePixels();

    //レシピ表示
    showRecipe();
  }
}

//肌色で2値化
void toFleshColorBinarizationIm(){
  for (int y = 0; y < video.height; ++y) {
    for (int x = 0; x < video.width; ++x) {
     int pixelColor = video.pixels[y*video.width + x];

     float h = hue(pixelColor);
     float s = saturation(pixelColor);
     float v = brightness(pixelColor);
      if (h >= 0 && h <= 30 && s >= 30 && v >= 50){//default 0<=h<=30,s>=30,v>=30
        video.pixels[y*video.width + x] = color(h, s, 100);
        // pixels[y * video.width + x] = color(3, 81, 50);
      }
      else{
        video.pixels[y*video.width + x] = color(h, s, 0);//color(59, 20, 50);
        // pixels[y * video.width + x] = color(3, 81, 50);
      }
    }
  }
}

//距離変換画像作成
void distTransform(){
  for (int y = 0; y < video.height; ++y) {
    for (int x = 0; x < video.width; ++x) {
      //toFleshColorBinarizationIm(video, x, y);
      int index = y * video.width + x;

      //距離画像作成
      //左上から右下へ
      float min = brightness(video.pixels[index]);
      if (x - 1 >= 0)
        min = min(min, brightness(video.pixels[y * video.width + (x-1)]) + 1);
      if(y - 1 >= 0)
        min = min(min, brightness(video.pixels[(y-1) * video.width + x]) + 1);
      video.pixels[index] = color(0, 0, min);
      // pixels[index] = color(0, 0, min * 10);
    }
  }
  //逆方向から
  for (int y = 0; y < video.height; ++y) {
    for (int x = 0; x < video.width; ++x) {
      int inv_x = video.width - 1 - x;
      int inv_y = video.height - 1 - y;
      int inv_index = inv_y * video.width + inv_x;
      float min = brightness(video.pixels[inv_index]);
      if(inv_x + 1 <= video.width - 1)
        min = min(min, brightness(video.pixels[inv_y * video.width + (inv_x + 1)]) + 1);
      if (inv_y + 1 <= video.height - 1)
        min = min(min, brightness(video.pixels[(inv_y + 1) * video.height + inv_x]) + 1);
      video.pixels[inv_index] = color(0, 0, min);
      // pixels[inv_index] = color(0, 0, min * 10);
    }
  }
}

//手の輪郭を求める
ArrayList<PVector> getHandVectors(){
  opcv.loadImage(video);
  //findContours(findHoles, sort) -> false, true
  ArrayList<Contour> contours = new ArrayList(opcv.findContours(false, true));

  Contour hand = contours.get(0); //一番面積の大きいものを手とする
  ArrayList<PVector> handVectors = hand.getPoints();
  return handVectors;
}

void findHandContour(){
  ArrayList<PVector> handVectors = (ArrayList<PVector>)getHandVectors().clone();
  for (int i = 0; i < handVectors.size(); ++i) {
    PVector hv = handVectors.get(i);
    int handIndex = int(hv.y * video.width + hv.x);
    pixels[handIndex] = color(3, 81, 50);
  }
}

void showRecipe(){
  float _x = 0, _y = 0;
  ArrayList<PVector> handVectors = (ArrayList<PVector>)getHandVectors().clone();

  for(int i = 0; i < handVectors.size(); i++){
    PVector hv = handVectors.get(i);
    // println("handX: " + handX + ", handY: " + handY);
    _x += hv.x;
    _y += hv.y;
  }
  float centerX = _x / handVectors.size();
  float centerY = _y / handVectors.size();
  // println("centerX: " + centerX + ", centerY: " + centerY);
  recipe.resize(300, 200);
  image(recipe, centerX - 100, centerY - 100);
}