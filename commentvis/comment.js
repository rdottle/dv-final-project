var listings;
var reviews;
var textvalue;
var listingSummary;
var reviewsComments;
var textbox = "";
var canvasHolder;

function preload(){
  listings = loadTable('data/listings_comments_join.csv', 'csv', 'header');
  reviews = loadTable('data/review_comments_join.csv', 'csv', 'header');
  console.log('done loading data');
  img = loadImage("pngicons/icons_all.png");
  print(listings.getColumn("summary"));

  }

function setup(){
    const canvasHolder = select('#canvasHolder'),
        canvasWidth  = canvasHolder.width,
        canvasHeight = canvasHolder.height;
  
  console.log(canvasHolder);
  print(canvasWidth + ', ' + canvasHeight);
   createCanvas(canvasWidth, canvasHeight).parent('canvasHolder');

   // for (var r = 0; r < listings.getRowCount(); r++)
   //    print(listings.getString(r, "summary"));
   //  for (var i = 0; i < reviews.getRowCount(); i++)
   //    reviewsComments = reviews.getString(i, "comments");
   //  // reviewsComments = reviews[]
      print(reviews.getString(0, "comments"));
    // var myCanvas = createCanvas(1500, 600);
    // myCanvas.parent("idnameofdiv");

 }


function draw(){
  background('rgba(253,160,45, 0.7)');
  image(img, 0, 0, 1024, 175);
  // text((floor(mouseX)), mouseX+20, mouseY+20);
  // text((floor(mouseY)), mouseX+30, mouseY+30);
  text(textbox, mouseX, mouseY+100);
}

// // When the user clicks the mouse
function mouseClicked() {
  // Check if mouse is inside the circle
  // var d = dist(mouseX, mouseY, 90, 78);
  if (mouseX > 20 && mouseX < 150 && mouseY > 40 && mouseY < 145 ){
    // Pick new random color values
    textbox = reviews.getString(0, "comments");
        textSize(16);

    }
  else if (mouseX > 200 && mouseX < 350 && mouseY > 25 && mouseY < 145){
    textbox = reviews.getString(3, "comments");
    textSize(16);
  }

  else if (mouseX > 415 && mouseX < 525 && mouseY > 25 && mouseY < 140){
    textbox = reviews.getString(4, "comments");
        textSize(16);

  }

  else if (mouseX > 620 && mouseX < 725 && mouseY > 25 && mouseY < 140){
    textbox = reviews.getString(6, "comments");
        textSize(16);

  }

   else if (mouseX > 830 && mouseX < 950 && mouseY > 25 && mouseY < 140){
   textbox = reviews.getString(7, "comments");
       textSize(16);

  }
}

// function mouseMoved() {
//   text(floor(mouseX), mouseX+20, mouseY+20);
//   text(floor(mouseY), mouseX+30, mouseY+30);
//   fill(0, 102, 153, 51);

  // prevent default
//   return false;
// }

