# misc-scripts

## GetCpdIds

The GetCpdIds script is applescript which does automatic compound numbering, as described here: https://web.archive.org/web/20131226191425/http://www.martinp23.com/blog/ 

Details copy/pasted below:

Something missing from ChemDraw-Word interoperability on Mac is compound numbering. In a report/thesis with hundreds of structures, it would be desirable to be able to automatically update compound numbers.

Typically, each compound in a report is assigned a number. The numbers are assigned sequentially, and are used to cross-reference the text to individual displays of structures, and structures embedded within schemes.

Looking at LaTeX, the chemscheme package manages to take a LaTeX file containing external links to .eps documents which contain chemical structures (these can be generated in ChemDraw) and convert reference tags within the text and the structures (of the form “TMP(something)”) to sequential numbers.

I wondered if similar might be possible for Word, for those of us stuck with it for the time being.

It turns out that Word (for Mac) cannot import EPS files as linked objects. With a linked object, changes to the source would be reflected in the document automagically. PNG files, however, can be linked.

So, I needed a different way to do it… unfortunately it’s a bit more awkward and only time will tell if it’s worthwhile.

The workflow:

Generate chemical structures and schemes saved in individual .cdxml files. Use labels of the form TMP(something)$. E.g., TMPAldehyde1$ or TMPBlergh$. Format them as you want them to appear in the final document. Tags are case-sensitive.
Use the “Save as..” option in ChemDraw to save copies of structures as PNG files. Put them in the same directory as the cdxml files. Make sure that corresponding .cdxml and .png files have the same name, excluding the extension.
Write your thesis. Reference structures as follows: “The compound was refluxed to afford TMPBlergh$.” The $ is essential and forms part of the tag. Again, format the reference as you wish it to appear in the final text.
Add structures to your thesis by going to Insert->Photo->From file.. and finding the .png you saved from ChemDraw. Make sure to click the “Link to file” checkbox, and consider checking the “Embed file” checkbox too.
Save everything
Close word
BACK UP ALL OF YOUR  MATERIAL, INCLUDING IMAGES.
REALLY BACK IT UP. I have generally just made a backup copy of my whole thesis folder.
Run the script below in AppleScript (I’d suggest doing it from the Applescript Editor). Follow the prompts at the top of the Finder windows and keep your fingers crossed.
Look at (Yourfilename).docx.withNumbers.docx for the processed version!
Note that this updates the .png files so if you go to the backed up original .docx, you will find that the images of structures and schemes contain numbers. If you make a change and re-run the script, these will be updated. Though if you do want to make a change, you’re probably best working from the backup you took and replacing the modified images.
What the script does

Asks for you to locate your thesis document
Copies the document to (name).docx.withNumbers.docx
Opens the (name).docx.withNumbers.docx file
Goes through the document (excluding text boxes!) looking for “TMP(anything)$” and stores each value in the order it finds it, in a list
Removes duplicates from the list of tags
Replaces all tags in the main text with a number indicating their position in the list. So the first tag is replaced with 1, the second with 2, etc.
Iterates over text boxes and replaces tags
 Saves the word doc and closes it.
Opens a Finder window to ask you to locate your folder containing .cdxml and the .pngs linked to your work document (must be the same directory!).
For each chemdraw file, it does the following:
Performs text substitutions to replace every occurrence of a “TMP..” tag with its respective number, to correspond to the substitutions in the word document. These are done without opening ChemDraw, but instead by modifying the cdxml file directly. A backup of the original .cdxml is taken as $filename.cdxml.bak
Opens each .cdxml file in chemdraw and Save as.. as a PNG.
Displays a “done” message.
For a 150 page report the script took some 15-20 mins to run. A lot of time is taken iterating over the Word document’s text boxes.

Invaluable sources:
1. [chemscheme](http://www.ctan.org/pkg/chemscheme) for LaTeX
2. [CDX to PNG](http://www.macinchem.org/applescript/cdx2png.php) from [MacInChem](http://www.macinchem.org)
3. Thanks to Chris from MacInChem for the [hint to avoid declaring](http://www.macinchem.org/blog/files/63ba35c12bf6dc127385a8ae0b2e2119-1219.php) a specific Chem(Bio)Draw version.

## readChemstationDAD

Matlab script to decode a chemstation binary file from a DAD into an array, so you can re-plot it. There are also ways to make ChemStation directly output ASCII data.
