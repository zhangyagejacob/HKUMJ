run("Open...");
fd=File.directory;

setBatchMode(true);
run("Duplicate...", "title=c123 duplicate channels=1-3");
run("Split Channels");

// roiManager("Select", 0);
// saveAs("Selection", fd + "//" + "\cytosol" + "//" + "\cytosol.roi");

roiManager("reset");
roiManager("Open", "");
roiManager("Select", 0);
sub = getInfo("roi.name"); //Roi.getName();
subfd = fd + "//" + sub;
File.makeDirectory(subfd);

selectWindow("C1-c123");
run("Reverse");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", subfd + "//" + "CH1.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 


selectWindow("C2-c123");
run("Reverse");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", subfd + "//" + "CH2.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 


selectWindow("C3-c123");
run("Reverse");
roiManager("Select", 0);
roiManager("Multi Measure");
saveAs("Results", subfd + "//" + "CH3.txt");
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

selectWindow("C3-c123");
close();
selectWindow("C2-c123");
close();
selectWindow("C1-c123");
close();


close();


setBatchMode(false); // displays the stack

