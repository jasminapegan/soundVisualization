import processing.core.*;

import static processing.core.PApplet.pow;
import static processing.core.PConstants.HSB;


public class Circle {

    PApplet sketch;
    float startingZ = 700;
    float projectionDist = 100f;
    float x, y, z, d;
    float xp, yp, dp;
    float z0 = -100000000;
    float toolbarY;

    Circle(PApplet sketch, float toolbarY) {
        // krog se pojavi na naključni lokaciji
        this.sketch = sketch;
        this.toolbarY = toolbarY;
        this.x = sketch.random(-sketch.width/2f, sketch.width/2f);
        this.y = sketch.random(-(sketch.height - toolbarY)/2f, (sketch.height - toolbarY)/2f);
        this.z = startingZ;
        this.d = sketch.random(0, sketch.width/10f);
    }

    void display(float amplitude, boolean major, float speed) {
        prepareColor(sketch, major, amplitude, true);

        // izračunaj x in y kot projekcijo iz treh koordinat
        this.xp = x * projectionDist/z + this.sketch.width / 2f;
        this.yp = -y * projectionDist/z + this.sketch.height / 2f;
        this.dp = (d + amplitude) * projectionDist/z;

        sketch.ellipse(xp, yp, dp, dp);

        z0 = z;
        this.z -= speed;

        // če krog uide iz polja, ga postavi na začetek
        if (isVisible()) {
            this.x = sketch.random(-width, width);
            this.y = sketch.random(-(height-toolbarY), (height-toolbarY));
            this.z = startingZ;
        }
    }

    boolean isVisible() {
      return (this.xp + this.d/2 > width ||
                this.xp - this.d/2 < 0 ||
                this.yp - this.d/2 < 0 ||
                this.yp + this.d/2 > height ||
                pow(this.d,2) > pow(height-toolbarY,2) + pow(width, 2));
    }
    /*
    boolean runsAwayFromCenter() {
      println(z);
      println(z0);
      println();
      return z < 2*startingZ && z0 < 2*z;
    }*/

}

public class Spectrum {
  float startingZ = -10000;
  float maxZ = 50;
  
  float x, y;
  float sizeX, sizeY;
  float[] freqs;
  
  PApplet sketch;
  
  Spectrum(PApplet sketch, float x, float y, float sizeX, float sizeY) {
    this.x = x;
    this.y = y;
    this.sketch = sketch;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  void display(float intensity, boolean major, float[] freqs) {
    this.freqs = freqs;
    
    
    for (int i=0; i < freqs.length; i++){
        float z = -20 + startingZ * 4*i / (freqs.length);
        float sizeX = 10*x / freqs.length;
        float sizeY = freqs[i]*10;
        
        prepareColor(sketch, major, intensity, false);
        sketch.fill(g.fillColor, (scoreGlobal/100)*(255+(z/25)));
        
        sketch.pushMatrix();
        rotateY(PI/60);
        rotateX(PI/60);
        sketch.translate(i*sizeX, y, z);    
        sketch.scale(sizeX, sizeY, sizeX);
        sketch.box(1);
        sketch.popMatrix();
    
  
        sketch.pushMatrix();
        rotateX(PI/60);
        sketch.translate(width-i*sizeX, y, z);    
        sketch.scale(sizeX, sizeY, sizeX);
        rotateY(-PI/60);
        sketch.box(1);
        sketch.popMatrix();
    }
  }
}

public class Wall {
  float startingZ = -10000;
  float maxZ = 50;
  
  float x, y, z;
  float sizeX, sizeY;
  
  PApplet sketch;
  
  Wall(PApplet sketch) {
    this.x = 0;
    this.y = 0;
    this.z = random(startingZ, maxZ);  
    this.sketch = sketch;
    this.sizeX = 0;
    this.sizeY = 0;
  }
  
  void display(float intensity, boolean major, float speed) {
    prepareColor(sketch, major, intensity, false);
    // črte izginjajo proti notranjosti - iluzija megle
    sketch.fill(g.fillColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    
    // wall 0
    x = 0;
    y = height/2;
    sizeX = 10;
    sizeY = height;
    
    sketch.pushMatrix();
    sketch.translate(x, y, z);
    if (intensity > 100) intensity = 100;
    sketch.scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    sketch.box(1);
    sketch.popMatrix();
    
    sketch.pushMatrix();
    sketch.translate(x, y, z);
    sketch.scale(sizeX, sizeY, 10);
    sketch.box(1);
    sketch.popMatrix();
    
    
    // wall 1
    x = width;
    y = height/2;
    sizeX = 10;
    sizeY = height;
    sketch.pushMatrix();
    sketch.translate(x, y, z);
    if (intensity > 100) intensity = 100;
    sketch.scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    sketch.box(1);
    sketch.popMatrix();
    
    sketch.pushMatrix();
    sketch.translate(x, y, z);
    sketch.scale(sizeX, sizeY, 10);
    sketch.box(1);
    sketch.popMatrix();
    
    
    // wall 2
    x = width/2;
    y = height;
    sizeX = width;
    sizeY = 10;
    sketch.pushMatrix();
    sketch.translate(x, y, z);
    if (intensity > 100) intensity = 100;
    sketch.scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    sketch.box(1);
    sketch.popMatrix();
    
    sketch.pushMatrix();
    sketch.translate(x, y, z);
    sketch.scale(sizeX, sizeY, 10);
    sketch.box(1);
    sketch.popMatrix();
    
    
    // wall 3
    x = width/2;
    y = 0;
    sizeX = width;
    sizeY = 10;
    sketch.pushMatrix();
    sketch.translate(x, y, z);
    if (intensity > 100) intensity = 100;
    sketch.scale(sizeX*(intensity/100), sizeY*(intensity/100), 20);
    sketch.box(1);
    sketch.popMatrix();
    
    sketch.pushMatrix();
    sketch.translate(x, y, z);
    sketch.scale(sizeX, sizeY, 10);
    sketch.box(1);
    sketch.popMatrix();
    
    this.z += speed;
    if (z >= maxZ) {
      z = startingZ;  
    }
  }
}


public void shift(float[] arr) {
    for (int i=0; i<arr.length-1; i++) {
      arr[i] = arr[i+1];
    }
}

public float avg(float[] arr) {
  float sum = 0;
  for (float f: arr) {
    sum += f;
  }
  return sum / arr.length;
}

public float avgSquared(float[] arr) {
  float sum = 0;
  for (float f: arr) {
    sum += f*f;
  }
  return sqrt(sum) / arr.length;
}


public float[] diffs(float[] arr) {
  float[] diffsArr = new float[arr.length - 1];
  for (int i=0; i < arr.length-1; i++) {
    diffsArr[i] = arr[i+1] - arr[i];
  }
  return diffsArr;
}


public float avgDiff(float[] arr) {
  //float sum = 0;
  //int n = arr.length - 1;
  float[] diffArr = diffs(arr);
  return avg(diffArr);
  
  /*for (int i=0; i < arr.length-1; i++) {
    float diff = diffArr[i];
    
    if (avg(diffArr) > 2.1 * diff || avg(diffArr) < 2.1 * diff) {
      println(avg(diffArr));
      n -= 1;
    } else {
      sum += diff;
    }
  }
  return sum / n;*/
}

public void prepareColor(PApplet sketch, boolean major, float amplitude, boolean saturate) {
  float highness = max(250, min(3*freqMax, 255));
  sketch.colorMode(HSB, 360, 255, 255);
  println(amplitude);
  if (major) {
      // warmer color -- 0 is warmest (red)
      if (saturate) {
        //sketch.fill(90 - int(scoreLow - scoreMid + scoreHi) % 180, 120+amplitude, highness, 200+amplitude);
        sketch.fill(90 - int(scoreLow + scoreMid + scoreHi) % 180, 60+10*amplitude, highness, 60+15*amplitude);
      } else {
        sketch.fill(90 - int(scoreLow + scoreMid + scoreHi) % 180, 60+10*amplitude, highness, 60+15*amplitude);
      }
  } else {
      // cooler color -- 180 is coolest (blue)
      if (saturate) {
        sketch.fill(90 + int(scoreLow + scoreMid + scoreHi) % 180, 60+10*amplitude, highness, 60+15*amplitude);
      } else {
        sketch.fill(90 + int(scoreLow + scoreMid + scoreHi) % 180, 60+10*amplitude, highness, 60+15*amplitude);
      }
  }  
  sketch.noStroke();
}
