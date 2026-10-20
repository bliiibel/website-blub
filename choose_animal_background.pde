// Start screen for choosing your characters 
void drawStartScreen() {
  background(#6C9DC6); 
  
  textAlign(CENTER, CENTER);
  textSize(40);
  fill(255);
  text("Choose your character!", width/2, 150);
   
  // Draws the characters for choosing 
  imageMode(CENTER);
  image(squid, 200, 350, width/7, height/7);
  image(turtle, 360, 350, width/6, height/6);
  image(seal, 530, 350, width/6, height/6);
  image(seahorse, 700, 350, width/6, height/6);

}
 // When character is pressed you start game with chosen character
void handleStartScreenClick() {
  if (mouseY > 280 && mouseY < 420) {
    
    if (mouseX > 130 && mouseX < 270) {
      startGameWithCharacter(squid);
    } 
    else if (mouseX > 290 && mouseX < 430) {
      startGameWithCharacter(turtle);
    } 
    else if (mouseX > 460 && mouseX < 600) {
      startGameWithCharacter(seal);
    } 
    else if (mouseX > 630 && mouseX < 770) {
      startGameWithCharacter(seahorse);
    }
  }
}


void startGameWithCharacter(PImage character) {
  selectedCharacter = character;
  charX = width / 2;  //  middle (X)
  charY = height / 2; // middle (Y)
  gameState = 1;      // Start the game!
}
