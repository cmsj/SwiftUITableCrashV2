STEPS TO REPRODUCE CRASH:
 1. Run app
 2. Drag a file from Finder onto the app window. A row will appear
 3. Select the new row
 4. Hit cmd+delete, the row will be removed
 5. Drag a file from Finder onto the app window.
 6. The app just crashed

Objections I have had from DTS so far and my arguments why they are wrong:

 * The Node objects should not be @Observable - this seems to be required for the Table to ever update when the node tree changes
 * The children property should be non-Optional - this is required for OutlineGroup to work.
