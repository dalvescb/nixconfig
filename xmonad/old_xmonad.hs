import XMonad

main = do
  xmonad $ def
    { terminal = myTerminal
    , modMask = myModMask
    , borderWidth = myBorderWidth }

myTerminal = "alacritty"
myModMask = mod4Mask -- Win key or Super _L
myBorderWidth = 3
