run("Open...");
fd=File.directory;
myDir=fd + "\cytosol"
File.makeDirectory(myDir);

setBatchMode(true);
run("Duplicate...", "title=c123 duplicate channels=1-3 slices=19"); // Z position
run("Split Channels");

roiManager("reset");
roiManager("Open", fd + "//" + "cytosol.roi");
roiManager("Select", 0);
// saveAs("Selection", fd + "//" + "\cytosol" + "//" + "\cytosol.roi");

selectWindow("C1-c123");
roiManager("Select", 0);
run("Measure");
selectWindow("C2-c123");
roiManager("Select", 0);
run("Measure");
selectWindow("C3-c123");
roiManager("Select", 0);
run("Measure");
saveAs("Results", fd + "//" + "\cytosol" + "//" + "\Results.txt");
selectWindow("C3-c123");
close();
selectWindow("C2-c123");
close();
selectWindow("C1-c123");
close();


   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

close();

setBatchMode(false); // displays the stack

