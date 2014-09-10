import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  //なにを検出したいか（ここを手に変えればできる？）
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
}

void draw() {
  scale(2);
  opencv.loadImage(video);
  //println("getH: "+opencv.getH()); -> null
  //これでRGBをHSBに変換
  opencv.useColor(PApplet.HSB);
  //println("getH: "+opencv.getH()); ->Matの内容が表示された
  opencv.blur(10, 10);
  image(video, 0, 0 );
  

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  //検出した顔の配列
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}

//一度captureしたら次の画像へ
void captureEvent(Capture c) {
  c.read();
}
