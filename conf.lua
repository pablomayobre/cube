love.conf = function (t)
	t.identity = "Cube"
	t.window.title = "Cube"
	t.author = "Positive07"
	t.url = "https://www.github.com/Positive07/Cube"
    t.version = "0.9.2"
	
    t.window.icon = "assets/icon.png"
    t.window.width = 600
    t.window.height = 500
	t.window.minwidth = 200
    t.window.minheight = 200
    t.window.borderless = false
    t.window.resizable = true

    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = true
    t.window.fsaa = 0
    t.window.display = 1
    t.window.highdpi = false
    t.window.srgb = false
	t.screen = t.window
end