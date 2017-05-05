var bargraph;
var places;
var w = 1200;
var h = 675;
var canvasHolder2;

function preload(){
  baseimg = loadImage("../img/allBars.png");
  apartment = loadImage("../img/apartment.png")
  descriptive = loadImage("../img/descriptiveWord.png")
  places = loadImage("../img/places.png")
  transportation = loadImage("../img/transportation.png")
  uncommon = loadImage("../img/uncommon.png")

}

function setup(){
  createCanvas(1500,800);
  const canvasHolder2 = select('#canvasHolder2'),
        canvasWidth  = canvasHolder2.width,
        canvasHeight = canvasHolder2.height;
  
  console.log(canvasHolder2);
  print(canvasWidth + ', ' + canvasHeight);
   createCanvas(canvasWidth, canvasHeight).parent('canvasHolder2');
  }

function draw(){
  background('rgba(242,94,162,0.7)');
  image(baseimg, 0, 0, 1200, 675);
  image(bargraph, 0, 0, w, h);

  //text((floor(mouseX)), mouseX+20, mouseY+20);
  //text((floor(mouseY)), mouseX+30, mouseY+30);
}

function mouseClicked() {
	if (mouseX > 132 && mouseX < 150 && mouseY > 75 && mouseY < 205 ){
		bargraph = image(apartment, 0, 0, w, h);
}
	else if (mouseX > 132 && mouseX < 150 && mouseY > 210 && mouseY < 278) {
		bargraph = image(places, 0, 0, w, h);
	}

	else if (mouseX > 132 && mouseX < 150 && mouseY > 280 && mouseY < 305) {
		bargraph = image(uncommon, 0, 0, w, h);
	}

	else if (mouseX > 132 && mouseX < 150 && mouseY > 309 && mouseY < 334) {
		bargraph = image(places, 0, 0, w, h);
	}

	else if (mouseX > 132 && mouseX < 150 && mouseY > 336 && mouseY < 360) {
		bargraph = image(transportation, 0, 0, w, h);
	}

	else if (mouseX > 132 && mouseX < 150 && mouseY > 363 && mouseY < 413) {
		bargraph = image(descriptive, 0, 0, w, h);
	}

	else if (mouseX > 132 && mouseX < 150 && mouseY > 415 && mouseY < 463) {
		bargraph = image(apartment, 0, 0, w, h);
	}

	else if (mouseX > 0 && mouseX < 1200 && mouseY > 0 && mouseY < 675) {
		bargraph = image(baseimg, 0, 0, w, h);
	}}

 //function mouseMoved() {
   //text(floor(mouseX), mouseX+20, mouseY+20);
   //text(floor(mouseY), mouseX+30, mouseY+30);
   //fill(255, 255, 255, 100);

  // prevent default
   //return false;}
