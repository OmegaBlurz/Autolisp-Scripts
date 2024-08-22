# Working

Script 1: Designate Layout Name (c:SetLayoutName)

The purpose of this script is to allow users to designate and store a custom layout name. It prompts the user to input a layout name and saves this name to a temporary text file. To use it, simply type SetLayoutName in the command line, input the desired layout name when prompted, and it will be stored for future use.

Script 2: Change Current Layout to Designated Name (c:ChangeLayoutName)

This script reads a previously saved layout name from a temporary file and renames the current layout to this name. To use it, type ChangeLayoutName in the command line, and it will automatically rename the current layout to the stored name, provided that the file exists.

Script 3: Invert Layer Visibility (c:INVERTLAYERVISIBILITY)

This script toggles the visibility and freeze/thaw state of all layers in the drawing, except for the "0" and "Defpoints" layers. To use it, type INVERTLAYERVISIBILITY in the command line, and it will invert the visibility and freeze state of the layers, providing confirmation once completed.

Script 4: HatchDel (c:HatchDel)

The purpose of this script is to delete all hatch objects from the drawing while managing layer status and showing progress feedback. To use it, type HatchDel in the command line, and the script will remove all hatch objects, handle the lock and freeze status of layers, and display progress throughout the operation.