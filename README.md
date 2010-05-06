Cube
====
##**All the changes in this branch are experimental and may not work at all**##
![Cube](https://github.com/Positive07/cube/blob/master/assets/cube.png)

Cube is an application made for [LÖVE](http://www.love2d.org), that is capable of running .love files

This allows you to modify the .love file behavior anyway you want without modifying the file itself.

The primary objetive of this project is to support a wide variety of LÖVE versions so that anyone can run any .love file in the latest version of LÖVE even if the file was designed for an older version itself.

This also means that game authors (Lovers) wont need to reimplement the game for the lastest LÖVE version. 

Other projects like [Vapor](https://www.github.com/josefnpat/Vapor) will benefit from it since they will able to support more Games
![Cube interface](https://github.com/Positive07/cube/blob/master/assets/screenshot.png)
###Support

We are in need of support, this project has many benefits like the sandbox, and the compatibility but it also brings troubles, so if you can help with any of this things please dont doubt to make a pull request or send me a PM

There is a somewhat complete list of missing features and needed things in this [Trello board](https://trello.com/b/LB5l35bS/cube)

If you find an issue or bug dont doubt on reporting it. If you want to give support in any other way send me a message

###Structure

This code is made so that it can be useful for other projects, this means that it doesnt use a monolithic structure, it is distributed in many files so that anyone can come and add (or take) things.

The structure is the following:

 * `assets`: This folders contains the assets of Cube, we try to use a minimal set of assets
 * `interface`: This is a folder containing the interface, like the drawing operations, the listing of files and folders, etc.
 * `run`: This folder contains fun things, this is what reads `.love` files and interprets `.lua` files, handles the environment, recognices the version and modifies the files.
 * `versions`: This folder contains the different LÖVE versions in separate folders, each folder contains a .lua file per LOVE module (`audio.lua`, `graphics.lua`, etc), and a `init.lua` file that groups them together
 * `utilities`: This are additional functions that lets Cube do neat things (like copying files to the save directory)

We will try to make the API simple so that other projects can use the `run` and the `versions` folders without the others.

###License

This project is Licensed under the MIT License, this means it is Open Source, you can do whatever you want with it (even sell it as part of your project), giving appropiate credits, and knowing that this is given without any warranty, this may be buggy and may blow your computer up so use it under your own risk, dont blame me