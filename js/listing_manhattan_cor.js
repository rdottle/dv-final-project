// ***** Global variables ***** //
var manCorTable;
var maxLength = 50;
var maxValue = 0;
var headers = ['ID field','list_man','list_man2']

// ***** Preload function ***** //
function preload(){
	manCorTable = loadTable('../data/listing_manhattan_cor.csv', 'csv', 'header');
	console.log('Done loading table...');
}

function setup(){
  //count the columns
  createCanvas(3000, 3000);
  textAlign(RIGHT, TOP);
  print(manCorTable.getRowCount() + " total rows in table");
  print(manCorTable.getColumnCount() + " total columns in table")
    for (var i = 0; i < manCorTable.getRowCount(); i++){
  maxValue = max(maxValue, manCorTable.getNum(i, 'list_man2'));
  }
  print(maxValue);
}


// ***** Draw function ***** //
function draw(){
  background(255);
  for (var i = 0; i < manCorTable.getRowCount(); i++){
    var rectlength = map(manCorTable.getNum(i, 'list_man2'), 0, maxValue, 0, maxLength);
    var wordCorMan = manCorTable.getString(i, 'list_man');
    var namelength = wordCorMan.length;
    var maxNameLength = max(namelength);
    rect(50 + 80 * i, 50 - rectlength, 15,rectlength);
    fill(0);
    textAlign(CENTER,TOP);
    text(wordCorMan, 50 + 80 * i, 60);
    textAlign(LEFT, TOP);
    //text(manCorTable.getNum(i, 'list_man2'), 50 + 20 * i, 150, 15,rectlength);


}
}

  
