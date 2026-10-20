import java.util.Random;

class TankBackground {
  color waterTop, waterBottom, sandColor;
  float timeOffset = 0; // Timer for Perlin noise. Increasing this makes the sand move over time.
  Random generator;     // Normal distribution

  TankBackground() {
    waterTop = color(#25C1B3);
    waterBottom = color(#143CA5);
    sandColor = color(#FAD2A2);
    generator = new Random();
  }

  void display() {
    drawWater();
    drawMovingSand(); // Includes the perlin noise

    // increment time to make the noise 'evolve'
    timeOffset += 0.005; // The higher the number the faster it moves (time)
  }

  // Draws a smooth color transition from top to bottom by drawing 600 lines
  void drawWater() {
    for (int i = 0; i <= height; i++) { // pixels from top to botom
      float inter = map(i, 0, height, 0, 1); // Convert the current line position 'i' to a value between 0.0 and 1.0
      color c = lerpColor(waterTop, waterBottom, inter); // Mix the top color and bottom color based on the percentage 'inter'
      stroke(c);
      line(0, i, width, i); // Draws 600 lines so there will be a color transition
    }
  }

  // perlin noise-> create a continuous, rolling landscape
  // using time as the 2nd parameter
  void drawMovingSand() {
    fill(sandColor);
    noStroke();
    
    beginShape();
    vertex(0, height); // Shape begins at the left bottom point

    for (int x = 0; x <= width; x += 5) { // Move across the screen from left to right in steps of 5 pixels
      
      // Get a Perlin noise value between 0.0 and 1.0 using x (space) and timeOffset (time).
      // 0.006 controls the shape. A small number makes the waves smooth and soft.
      float noiseVal = noise(x * 0.006, timeOffset); 
      
      // Calculate the Y position for the sand.
      // 'height - 110' sets the base height. 'noiseVal * 50' adds waves up to 50 pixels high.
      float y = height - 110 + (noiseVal * 50);
      vertex(x, y);
    }

    vertex(width, height);
    endShape(CLOSE);
  }
}
