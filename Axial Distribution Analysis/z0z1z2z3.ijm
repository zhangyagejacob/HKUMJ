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
Stack.setChannel(3);
run("Enhance Contrast", "saturated=0.66"); 

// ROI for Camera Background

myDir=fd + "bk" 
File.makeDirectory(myDir);

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
Stack.setChannel(3);
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
selectWindow("C3-c123");
run("Reverse");

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

selectWindow("C3-c123");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", subfd + "//" + "CH3.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

}

run("Close All");

// end of axial measurement of all podosome ROIs


selectWindow("Log");
run("Close"); // close Log window



