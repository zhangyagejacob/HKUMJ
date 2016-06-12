// Copyright by yage zhang, zhangyg@hku.hk
// Draw a line across the invadopodia
// Used to define the weight of three zones of the invadopodia

run("Close All");

run("Open...");
fd=File.directory;
icsids=File.name;
icsidsfile = fd+icsids;

myDir=fd+"mscan";
File.makeDirectory(myDir);
roiManager("reset");
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

selectWindow(icsids);
run("Duplicate...", "title=c123 duplicate channels=1-3");
selectWindow(icsids);
run("Split Channels");

selectWindow("C1-"+icsids);
roiManager("Select", 0);
run("Clear Results");
  profile1 = getProfile();
  for (i=0; i<profile1.length; i++)
      setResult("Value", i, profile1[i]);
  updateResults;
  selectWindow("Results");
saveAs("Text", fd + "//" + "mscan" + "//" + "CH1-mscan.txt");

selectWindow("C2-"+icsids);
roiManager("Select", 0);
run("Clear Results");
  profile2 = getProfile();
  for (i=0; i<profile2.length; i++)
      setResult("Value", i, profile2[i]);
  updateResults;
  selectWindow("Results");
saveAs("Text", fd + "//" + "mscan" + "//" + "CH2-mscan.txt");

run("Clear Results");
selectWindow("C3-"+icsids);
roiManager("Select", 0);
  profile3 = getProfile();
  for (i=0; i<profile3.length; i++)
      setResult("Value", i, profile3[i]);
  updateResults;
selectWindow("Results");
saveAs("text", fd + "//" + "mscan" + "//" + "CH3-mscan.txt");

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 


selectWindow("C1-"+icsids);
close();
selectWindow("C2-"+icsids);
close();
selectWindow("C3-"+icsids);
close();

selectWindow("c123");
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.66"); 
Stack.setChannel(3);
run("Enhance Contrast", "saturated=0.66"); 
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.66"); 

// ROI for Camera Background
myDir=fd + "bk";
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

run("Close All");

selectWindow("Log");
run("Close"); // close Log window