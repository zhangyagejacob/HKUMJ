// Copyright Cheng-han Yu, chyu1@hku.hk
// Amended by zhangyg
// Assign camera background ROI and measure at 1um above the substrate
// Assign linescan ROI across plasma membrane at 1um above the substrate
// Measure the intensity at plasma membrane

run("Close All");

run("Open...");
fd=File.directory;
icsids=File.name;
icsidsfile = fd+icsids;  // reopen the icsids file 

  Dialog.create("Number of Z stack");
  Dialog.addNumber("Number of Z stack:", 10);
  Dialog.show();
  zm = Dialog.getNumber();
  print("Reference plane (1000nm above) =   " + zm);	
  // reference plane is the 6th (1000nm) above the interface

run("Duplicate...", "title=c123 duplicate channels=1-2 slices=1 frames=1"); // Z position
selectWindow(icsids);
close();
selectWindow("c123");

/*
  if (Stack.isHyperStack)
      print("Stack.isHyperStack: true");
  else
      print("Stack.isHyperStack: false");

print("Get Dimensions");
  getDimensions(w, h, channels, slices, frames);
  Stack.getPosition(channel, slice, frame);
  print("   Chanels: "+channels);
  print("   Slices: "+slices);
  print("   Frames: "+frames);
  print("Position (before): "+channel+", "+slice+", "+frame);
*/
  
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.66"); 
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.66"); 

// mbk.roi, camera background
// mscan.roi, membrane linescan at 1000nm above 

// Camera background
// Camera background

myDir=fd + "mbk";
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

// Cytosol background
// Cytosol background

myDir2=fd + "mcytosol";
File.makeDirectory(myDir2);

print("<<Camera Background>>");	
setTool("oval");
roiManager("reset");
waitForUser("  << Click Add >> ROI of Cytosol Background,  ");
roiManager("Select", 0);
roiManager("Rename", "mcytosol");
saveAs("Selection", fd + "//" + "mcytosol.roi"); 
roiManager("Multi Measure");
saveAs("Results", fd + "//" + "mcytosol" + "//" + "Results.txt");

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

roiManager("reset");

// End of Cytosol background
// End of Cytosol background

// Assign linescan ROI
// Assign linescan ROI

myDir3=fd + "mscan";
File.makeDirectory(myDir3);

print("<<outside-to-inside linecan at membrane, 5um in length>>");	
setTool("line");
run("Line Width...", "line=11"); 
roiManager("reset");
waitForUser("  Draw a 5um lines, from outside to inside, and Plot Profile  ");
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
 	selectWindow("C2-c123");
	roiManager("Select", 0);
	roiManager("Multi Measure");
	saveAs("Results", subfd + "//" + "CH2.txt");
   	if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   	} 
 */

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   }
run("Close All");


selectWindow("Log");
run("Close"); // close Log window

