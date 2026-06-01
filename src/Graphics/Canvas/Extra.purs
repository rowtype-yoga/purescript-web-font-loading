-- | The handful of 2D-context settings and the offscreen-canvas constructor that
-- | `Graphics.Canvas` (the `canvas` package) does not bind.
module Graphics.Canvas.Extra
  ( createCanvasElement
  , LetterSpacing(..)
  , setLetterSpacing
  , FontKerning
  , kerningAuto
  , kerningNormal
  , kerningNone
  , setFontKerning
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import Graphics.Canvas (CanvasElement, Context2D)

-- | A fresh, detached `<canvas>` element, not attached to the document — handy as
-- | an offscreen drawing surface (e.g. a texture source).
createCanvasElement :: Effect CanvasElement
createCanvasElement = createCanvasElementImpl

foreign import createCanvasElementImpl :: Effect CanvasElement

-- | A CSS length controlling extra space between glyphs, e.g. `8px`.
newtype LetterSpacing = LetterSpacing String

derive newtype instance Eq LetterSpacing
derive newtype instance Ord LetterSpacing
derive newtype instance Show LetterSpacing

-- | Set the context's `letterSpacing`.
setLetterSpacing :: Context2D -> LetterSpacing -> Effect Unit
setLetterSpacing = runEffectFn2 setLetterSpacingImpl

foreign import setLetterSpacingImpl :: EffectFn2 Context2D LetterSpacing Unit

-- | Whether the context applies font kerning.
newtype FontKerning = FontKerning String

derive newtype instance Eq FontKerning
derive newtype instance Ord FontKerning
derive newtype instance Show FontKerning

kerningAuto :: FontKerning
kerningAuto = FontKerning "auto"

kerningNormal :: FontKerning
kerningNormal = FontKerning "normal"

kerningNone :: FontKerning
kerningNone = FontKerning "none"

-- | Set the context's `fontKerning`.
setFontKerning :: Context2D -> FontKerning -> Effect Unit
setFontKerning = runEffectFn2 setFontKerningImpl

foreign import setFontKerningImpl :: EffectFn2 Context2D FontKerning Unit
