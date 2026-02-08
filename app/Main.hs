-----------------------------------------------------------------------------
{-# LANGUAGE CPP               #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE MultilineStrings  #-}
{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
module Main where
-----------------------------------------------------------------------------
import           Miso
import           Miso.Html
import           Miso.FFI.QQ (js)
import qualified Miso.CSS as CSS
import           Miso.Html.Property
-----------------------------------------------------------------------------
#ifdef WASM
#ifndef INTERACTIVE
foreign export javascript "hs_start" main :: IO ()
#endif
#endif
-----------------------------------------------------------------------------
main :: IO ()
#ifdef INTERACTIVE
main = reload (startApp mempty app)
#else
main = startApp mempty app
#endif
-----------------------------------------------------------------------------
data Action = InitMathJAX DOMRef
-----------------------------------------------------------------------------
type Model = ()
-----------------------------------------------------------------------------
app :: App Model Action
app = component () updateModel viewModel
-----------------------------------------------------------------------------
updateModel :: Action -> Effect ROOT Model Action
updateModel = \case
  InitMathJAX domRef -> io_
    [js| MathJax.typesetPromise([${domRef}]).then(() => { console.log('typeset!'); }); |]
-----------------------------------------------------------------------------
viewModel :: () -> View Model Action
viewModel () = div_
  [ ]
  [ h2_
    [ CSS.style_
      [ CSS.fontFamily "monospace"
      ]
    ]
    [ "🍜 🧮 "
    , a_
      [ href_ "https://github.com/haskell-miso/miso-mathjax"
      ]
      [ "miso-mathjax"
      ]
    ]
  , hr_ []
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
