# Autolisp Scripts

A collection of my and others autolisp scripts that I use.

## Usage

Upon discovering one of the GOATs of autocad lisp programming [Lee Mac](https://www.lee-mac.com/), I will now list two methods.

Clone or Download then unzip this repo to somewhere on your PC you can access later.

### Dynamic [Autoloader](https://www.lee-mac.com/autoloader.html) (Can't personally get this to work)

Using ```Appload``` load ```Autoloader.lsp``` and run the command AutoLoader and select the folder containing Functional to generate it's output .txt file 

For easiest use load .lsp file within acad{year}doc.lsp located within "{Autocad Installation Folder}\Support\en-us\\" by pasting each individual filepath within a load function.

e.g.

``` lisp
;;;=== User Macros ===

(load "C:\\Example\\Filepath\\ZoomSaveClose.lsp")
```

### [ACADDOC.lsp Creator](https://www.lee-mac.com/acaddoccreator.html) (Recommended)

## Scripts

- Funtional
  - ZoomSave
  - ZoomSaveClose
  - SetLineTypeScales
  - SetLayoutName
  - ChangeLayoutName
  - InvertLayers
  - DIMDEL
  - delwipeout
  - hatchdel

- Non-Functional
  - LayerFreeze
  - SetToLayer0
