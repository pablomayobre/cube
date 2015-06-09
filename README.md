Cube
====
![Cube Logo](https://github.com/Positive07/cube/blob/master/assets/logo.png)

Cube is an application (and library) made for LÖVE, that is capable of running .love files **(SO META!)**

The primary objetive of this project is to support a wide variety of LÖVE versions so that anyone can run any .love file in the latest version of LÖVE even if the file was designed for an older version itself.

Other projects like Vapor will benefit from it since they will able to support outdated games.

**_NOTE:_ This is yet a Work In Progress (WIP) there are lot of uncommitted files and missing things, no test have been performed yet so this is not ready for distribution in any sense!**

## Application

The application part is the same as LÖVE, basically an executable to which you can drop your file on and just run it.

This is useful for running outdated projects, the only problem being that it needs to copy the file to the save directory (so it is slow)

You can fix this by dropping the file in the save directory, then you can call Cube as follows:

```shell
cube yourgame.love --appdata
```

Another alternative is changing the save directory identity of Cube:

```shell
cube yourgame.love --appdata="NewIdentity"
```

### Download

Download this application from the releases [here](https://github.com/Positive07/cube/releases/tag/0.4.0-executable)

If you are interested in the source code just check the [`main.lua` file](https://github.com/Positive07/cube/blob/master/main.lua)

## Library

To grab this library you can `git clone` this repo (I recommend you go to the [`library` branch](https://github.com/Positive07/cube/tree/library), which contains just the library related files)

```shell
git clone https://github.com/Positive07/cube.git
git checkout library
```

Alternatively you can download a `.zip` or `.tar.gz` from the [Releases](https://github.com/Positive07/cube/releases/tag/0.4.0-library).

### Usage

Usage is very simple, just drop the cube folder in your project, then `require "cube"` and start using it!

Here is a basic sample script:

```lua
local cube = require "cube"

myapp = cube.new("myapp.love")

myapp:onPump(function () print("love.event.pump was called by myapp.love") end

myapp:run()
```

To have more info on all the available functions check the [wiki](https://github.com/Positive07/cube/wiki).

## License

Cube is Licensed under **[MIT License][9]**

Copyright(c) 2015 Pablo Ariel Mayobre (Positive07).
