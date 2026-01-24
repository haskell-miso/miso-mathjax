# :ramen: 🧮 miso-mathjax

An example integration of [miso](https://github.com/dmjio/miso) and [MathJAX](https://www.mathjax.org/).

```haskell
-----------------------------------------------------------------------------
{-# LANGUAGE CPP               #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
module Main where
-----------------------------------------------------------------------------
import           Miso
import           Miso.Html
import qualified Miso.CSS as CSS
import           Miso.Html.Property
-----------------------------------------------------------------------------
main :: IO ()
main = run (startApp mempty app)
-----------------------------------------------------------------------------
data Action = InitMathJAX DOMRef
-----------------------------------------------------------------------------
type Model = ()
-----------------------------------------------------------------------------
app :: App Model Action
app = component () updateModel viewModel
-----------------------------------------------------------------------------
updateModel :: Action -> Transition Model Action
updateModel = \case
  InitMathJAX domRef -> io_ $ do
    () <- inline """
      MathJax.typesetPromise([domRef]).then(() => { console.log('typeset!'); });
    """ =<< createWith [ "domRef" =: domRef ]
    pure ()
-----------------------------------------------------------------------------
viewModel :: () -> View Model Action
viewModel () = div_
  [ ]
  [ h2_
    [ CSS.style_
      [ CSS.fontFamily "monospace"
      ]
    ]
    [ "🍜 🧮 miso-mathjax"
    ]
  , div_
    [ id_ "math-container"
    , onCreatedWith InitMathJAX
    ]
    [ "$$x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$$"
    ]
  , hr_ []
  , div_
    [ id_ "math-container"
    , onCreatedWith InitMathJAX
    ]
    [ "$$E = mc^2$$"
    ]
  ]
-----------------------------------------------------------------------------
```

## Build and run

Install [Nix Flakes](https://nixos.wiki/wiki/Flakes), then:

```
nix develop .#wasm
make
make serve
```
