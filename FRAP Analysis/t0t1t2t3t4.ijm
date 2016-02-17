// Copyright Cheng-han Yu, chyu1@hku.hk
// Assign camera background ROI and measure, bk.roi, camera background
// Assign cytosol background ROI and measure, cytosol.roi, cytosol bleach correction
// Assign kymo.roi, kymograph linescan of the FRAP area, from outside to inside
//Assign zone, zone1.zip fast recovery (regular), zone2.zip slow recovery

run("Close All");

run("Open...");
fd=File.directory;
icsids=File.name;
icsidsfile = fd+icsids;  // reopen the icsids file 

// Camera background 
// Camera background 

myDir=fd + "bk"
File.makeDirectory(myDir);

run("Z Project...", "start=2 stop=4"); // average frame 2, 3, and 4
selectWindow(icsids);
close();

// ROI for Camera Background

myDir=fd + "bk"; 
File.makeDirectory(myDir);

print("<<Camera Background>>");	
setTool("oval");
roiManager("reset");
waitForUser("  <1> Assign ROI of Camera Background, then <2> Click Add.   ");
roiManager("Select", 0);
roiManager("Rename", "bk");
saveAs("Selection", fd + "//" + "bk.roi"); 
roiManager("Multi Measure");
saveAs("Results", fd + "//" + "bk" + "//" + "\Results.txt");

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

roiManager("reset");

// Cytosol bleach correction
// Cytosol bleach correction

myDir2=fd + "cytosol";
File.makeDirectory(myDir2);

run("Close All");
run("Open...", "open=icsidsfile");
run("Duplicate...", "title=c123 duplicate channels=1-3");
selectWindow(icsids);
close();

selectWindow("c123");
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.66"); 
Stack.setChannel(3);
run("Enhance Contrast", "saturated=0.66"); 
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.66"); 

print("<<Cytosol Bleach Correction>>");	
setTool("oval");
roiManager("reset");
waitForUser("  <1> Assign ROI of Cytosol Bleach Correction, then <2> Click Add  ");
roiManager("Select", 0);
roiManager("Rename", "cytosol");
saveAs("Selection", fd + "//" + "cytosol.roi"); 

run("Split Channels");

selectWindow("C1-c123");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", fd + "//" + "cytosol" + "//" + "cyto-CH1.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

selectWindow("C2-c123");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", fd + "//" + "cytosol" + "//" + "cyto-CH2.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

selectWindow("C3-c123");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", fd + "//" + "cytosol" + "//" + "cyto-CH3.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

run("Close All");

// Assign kymo ROI
// Assign kymo ROI

run("Open...", "open=icsidsfile");

selectWindow(icsids);
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.66"); 
Stack.setChannel(3);
run("Enhance Contrast", "saturated=0.66"); 
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.66"); 

print("<<outside-to-inside linecan (15um) at bleached podosome>>");	
setTool("line");
run("Line Width...", "line=1"); 
roiManager("reset");

waitForUser("  Assign a 15um LINE ROI across bleached podosome (from outside to inside), and <2> Click Add  ");
roiManager("Select", 0);
roiManager("Rename", "kymo");
saveAs("Selection", fd + "//" + "kymo.roi"); 

// Generate kymograph of the FRAP area, in the same folder
// Generate kymograph of the FRAP area, in the same folder

run("Duplicate...", "title=c123 duplicate channels=1-3");
run("Split Channels");

roiManager("reset");
roiManager("Open", fd + "//" + "kymo.roi");
roiManager("Select", 0);

selectWindow("C1-c123");
roiManager("Select", 0);
run("Reslice [/]...", "output=1.000 slice_count=1 avoid");

selectWindow("C2-c123");
roiManager("Select", 0);
run("Reslice [/]...", "output=1.000 slice_count=1 avoid");

selectWindow("C3-c123");
roiManager("Select", 0);
run("Reslice [/]...", "output=1.000 slice_count=1 avoid");

run("Merge Channels...", "c1=[Reslice of C1-c123] c2=[Reslice of C2-c123] c3=[Reslice of C3-c123] create");
selectWindow("Composite");
Stack.setDisplayMode("color");
run("Rotate 90 Degrees Left");
saveAs("Tiff", fd + "//" + "kymoComposite.tif");

run("Close All");

// Assign ROI of zone1, fast recovery, normal
// Assign ROI of zone2, slow recovery, rare

open(fd + "//" + "kymoComposite.tif");
run("In [+]");
run("In [+]");
run("In [+]");
run("In [+]");

  Dialog.create("Number of zones");
  Dialog.addNumber(" Number of zones to measure: ", 1);
  Dialog.show();
  kymozone = Dialog.getNumber();
  // kymozone: total number of zone1

// zone1, fast recovery, normal
// zone2, slow recovery, rare

// start of the loops for adding zone
for (i=0; i<kymozone; i++) {
i1=i+1;
kymozonefile = "zone"+i1;  // zonei file name
setTool("rectangle");
roiManager("reset");
Stack.setChannel(3);
waitForUser("  <1> Assign ROI of bleached zone #" +i1 +";   Then <2> Click Add");
roiManager("Select", 0);
roiManager("Rename", kymozonefile);
roiManager("Save Selected", fd + "//" + kymozonefile+ ".zip");
roiManager("reset");
}

run("Close All");

// Measure intensity of FRAP at podosome
// Measure intensity of FRAP at podosome

open(fd + "//" + "kymoComposite.tif");
run("Duplicate...", "title=c123 duplicate channels=1-3");
run("Split Channels");

setBatchMode(true);

for (j=0; j<kymozone; j++) {
j1=j+1;
kymozonefile = "zone"+j1;  // zonei file name
roiManager("reset");
roiManager("Open", fd + "//" + kymozonefile+ ".zip");
roiManager("Select", 0);
subfd = fd + "//" + kymozonefile;
File.makeDirectory(subfd);

selectWindow("C1-c123");
roiManager("Select", 0);
run("Clear Results");
  profile1 = getProfile();
  for (i=0; i<profile1.length; i++){
      setResult("Value", i, profile1[i]);
  updateResults;
  selectWindow("Results");
saveAs("Text", subfd + "//" + "CH1-" + kymozonefile + ".txt");
  }
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

selectWindow("C2-c123");
roiManager("Select", 0);
run("Clear Results");
  profile2 = getProfile();
  for (i=0; i<profile2.length; i++){
      setResult("Value", i, profile2[i]);
  updateResults;
  selectWindow("Results");
saveAs("Text", subfd + "//" + "CH2-" + kymozonefile + ".txt");
  }
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

run("Clear Results");
selectWindow("C3-c123");
roiManager("Select", 0);
  profile3 = getProfile();
  for (i=0; i<profile3.length; i++){
      setResult("Value", i, profile3[i]);
  updateResults;
selectWindow("Results");
saveAs("Text", subfd + "//" + "CH3-" + kymozonefile + ".txt");
  }
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 
}
  

run("Close All");

////

setBatchMode(false); // displays the stack

selectWindow("Log");
run("Close"); // close Log window

