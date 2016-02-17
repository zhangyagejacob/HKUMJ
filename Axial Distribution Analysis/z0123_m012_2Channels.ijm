// Copyright Cheng-han Yu, chyu1@hku.hk
// Assign camera background ROI and measure
// Assign cytosol background ROI and measure
// Assign each podosome ROI 
// Measure axial intensity at each podosome roi

run("Close All");

run("Open...");
fd=File.directory;
icsids=File.name;
icsidsfile = fd+icsids;  // reopen the icsids file 

  Dialog.create("Number of Z stack");
  Dialog.addNumber("Number of Z stack:", 21);
  Dialog.show();
  zpds = Dialog.getNumber()-2;
  print("Reference plane (zMax minus 2, 400nm above) =   " + zpds); 
  // reference plane is the 3rd (400nm) above the interface

run("Duplicate...", "title=c123 duplicate channels=1-3 slices=zpds"); // Z position
selectWindow(icsids);
close();
selectWindow("c123");
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.66"); 
//Stack.setChannel(3);
//run("Enhance Contrast", "saturated=0.66"); 
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.66"); 

// ROI for Camera Background

myDir=fd + "bk" 
File.makeDirectory(myDir);

myDir1=fd + "mbk";
File.makeDirectory(myDir1);

print("<<Camera Background>>"); 
setTool("oval");
roiManager("reset");
waitForUser("  << Click Add >> ROI of Camera Background  ");
roiManager("Select", 0);
roiManager("Rename", "bk");
saveAs("Selection", fd + "//" + "bk.roi"); 
roiManager("Multi Measure");
saveAs("Results", fd + "//" + "bk" + "//" + "\Results.txt");

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

roiManager("Multi Measure");
saveAs("Results", fd + "//" + "mbk" + "//" + "\Results.txt");

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

roiManager("reset");

// ROI for Cytosol Background

myDir2=fd + "cytosol";
File.makeDirectory(myDir2);

print("<<Cytosol Background>>");  
setTool("oval");
roiManager("reset");
waitForUser("  << Click Add >> ROI of Cytosol Background  ");
roiManager("Select", 0);
roiManager("Rename", "cytosol");
saveAs("Selection", fd + "//" + "cytosol.roi"); 
roiManager("Multi Measure");
saveAs("Results", fd + "//" + "cytosol" + "//" + "\Results.txt");

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

roiManager("reset");

// Podosome ROI

print("<<Podosome ROIs>>, tolerance value ~ 10000");  

  Dialog.create("Number of podosomes");
  Dialog.addNumber(" Number of podosomes to measure: ", 3);
  Dialog.show();
  npds = Dialog.getNumber();
  // npds: total number of podosome ROI

// start of the loops for adding podosome ROI

for (i=1; i<=npds; i++) {
pdsifile = "pds"+i;  // pdsi file name
setTool("wand");
run("Wand Tool...");
roiManager("reset");
Stack.setChannel(1);
waitForUser("  << Click Add >> ROI of Podosome #"+i);
roiManager("Select", 0);
roiManager("Rename", pdsifile);
roiManager("Save Selected", fd + "//" + pdsifile+ ".zip");
roiManager("reset");
}

// stop of the loops for adding podosome ROI
// stop of the loops for adding podosome ROI

// Axial intensity of three channels at the podosome ROI
// Axial intensity of three channels at the podosome ROI

run("Close All");
run("Open...", "open=icsidsfile");

  // npds: total number of podosome ROI
  //setBatchMode(true);

run("Duplicate...", "title=c123 duplicate channels=1-3");
run("Split Channels");
selectWindow("C1-c123");
run("Reverse");
selectWindow("C2-c123");
run("Reverse");
//selectWindow("C3-c123");
//run("Reverse");

// start of the loops for all podosome ROI
for (i=1; i<=npds; i++) {
pdsifile = "PDS"+i;  // pdsi file name
roiManager("reset");
roiManager("Open", fd + "//" + pdsifile+ ".zip");
roiManager("Select", 0);
// sub = getInfo("roi.name"); //Roi.getName();
subfd = fd + "//" + pdsifile;
File.makeDirectory(subfd);

selectWindow("C1-c123");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", subfd + "//" + "CH1.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

selectWindow("C2-c123");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", subfd + "//" + "CH2.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 
/*
selectWindow("C3-c123");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", subfd + "//" + "CH3.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 
*/
}

run("Close All");

// end of axial measurement of all podosome ROIs


selectWindow("Log");
run("Close"); // close Log window

// Copyright Cheng-han Yu, chyu1@hku.hk
// Assign camera background ROI and measure at 1um above the substrate
// Assign linescan ROI across plasma membrane at 1um above the substrate
// Measure the intensity at plasma membrane

run("Close All");

run("Open...");
fd=File.directory;
icsids=File.name;
icsidsfile = fd+icsids;  // reopen the icsids file 


  Dialog.create("Number of Z stack");
  Dialog.addNumber("Number of Z stack:", 21);
  Dialog.show();
  zm = Dialog.getNumber()-5;
  print("Reference plane (zMax minus 5, 1000nm above) =   " + zm);	
  // reference plane is the 6th (1000nm) above the interface

run("Duplicate...", "title=c123 duplicate channels=1-3 slices=zm"); // Z position
selectWindow(icsids);
close();
selectWindow("c123");
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.66"); 
//Stack.setChannel(3);
//run("Enhance Contrast", "saturated=0.66"); 
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.66"); 



// mbk.roi, camera background
// mscan.roi, membrane linescan at 1000nm above 

/*
// Camera background
// Camera background

myDir=fd + "mbk" 
File.makeDirectory(myDir);

print("<<Camera Background>>");	
setTool("oval");
roiManager("reset");
waitForUser("  << Click Add >> ROI of Camera Background,  ");
roiManager("Select", 0);
roiManager("Rename", "mbk");
saveAs("Selection", fd + "//" + "mbk.roi"); 
roiManager("Multi Measure");
saveAs("Results", fd + "//" + "mbk" + "//" + "Results.txt");

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

roiManager("reset");

// End of Camera background 
// End of Camera background

*/

// Assign linescan ROI
// Assign linescan ROI

myDir2=fd + "mscan";
File.makeDirectory(myDir2);

print("<<outside-to-inside linecan at membrane, 10um in length>>");	
setTool("line");
run("Line Width...", "line=11"); 
roiManager("reset");
waitForUser("  Draw a 10um lines, from outside to inside, and Plot Profile  ");
run("Plot Profile");
waitForUser("  << Click Add >> ROI of linescan");
roiManager("Select", 0);
roiManager("Rename", "mscan");
saveAs("Selection", fd + "//" + "mscan.roi"); 
run("Measure");
saveAs("Results", fd + "//" + "mscan" + "//" + "length.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 
// mscan.roi draw from outside to inside of the cell

// measure profile at ROI
// measure profile at ROI

selectWindow("c123");
run("Split Channels");

selectWindow("C1-c123");
roiManager("Select", 0);
run("Clear Results");
  profile1 = getProfile();
  for (i=0; i<profile1.length; i++)
      setResult("Value", i, profile1[i]);
  updateResults;
  selectWindow("Results");
saveAs("Text", fd + "//" + "mscan" + "//" + "CH1-mscan.txt");

selectWindow("C2-c123");
roiManager("Select", 0);
run("Clear Results");
  profile2 = getProfile();
  for (i=0; i<profile2.length; i++)
      setResult("Value", i, profile2[i]);
  updateResults;
  selectWindow("Results");
saveAs("Text", fd + "//" + "mscan" + "//" + "CH2-mscan.txt");

/*
run("Clear Results");
selectWindow("C3-c123");
roiManager("Select", 0);
  profile3 = getProfile();
  for (i=0; i<profile3.length; i++)
      setResult("Value", i, profile3[i]);
  updateResults;
selectWindow("Results");
saveAs("text", fd + "//" + "mscan" + "//" + "CH3-mscan.txt");
*/
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

run("Close All");


selectWindow("Log");
run("Close"); // close Log window

