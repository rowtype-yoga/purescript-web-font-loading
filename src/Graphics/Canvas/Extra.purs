-- | Native canvas capabilities not provided by `Graphics.Canvas`.
module Graphics.Canvas.Extra
  ( createCanvasElement
  , createOffscreenCanvas
  , supportsOffscreenCanvas
  , supportsCanvasElement
  , isOffscreenCanvas
  , getContext2DNullable
  , contextCanvas
  , resetContext
  , measureTextInk
  , FillRule(..)
  , clipWithRule
  , setFilter
  , createPatternNullable
  , setPatternTransform
  , LetterSpacing(..)
  , setLetterSpacing
  , FontKerning
  , kerningAuto
  , kerningNormal
  , kerningNone
  , setFontKerning
  ) where

import Prelude

import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import Graphics.Canvas (CanvasElement, CanvasImageSource, CanvasPattern, Context2D, PatternRepeat(..), Transform)

-- | A fresh, detached `<canvas>` element, not attached to the document — handy as
-- | an offscreen drawing surface (e.g. a texture source).
createCanvasElement :: Effect CanvasElement
createCanvasElement = createCanvasElementImpl

foreign import createCanvasElementImpl :: Effect CanvasElement

foreign import supportsCanvasElement :: Effect Boolean

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

-- | Construct a native worker-compatible surface. Throws when OffscreenCanvas
-- | is unavailable; callers can choose another surface using the capability query.
createOffscreenCanvas :: Number -> Number -> Effect CanvasElement
createOffscreenCanvas = runEffectFn2 createOffscreenCanvasImpl

-- | Unlike detached DOM canvases, these surfaces are available in workers.
foreign import supportsOffscreenCanvas :: Effect Boolean

foreign import isOffscreenCanvas :: CanvasElement -> Effect Boolean

-- | Preserve the native null result when the context type is unavailable or the
-- | surface has already been bound to a different context type.
foreign import getContext2DNullable :: CanvasElement -> Effect (Nullable Context2D)

foreign import contextCanvas :: Context2D -> Effect CanvasElement

-- | Use the native reset operation when available. On older implementations,
-- | restore the identity transform and clear the bitmap without resizing it.
foreign import resetContext :: Context2D -> Effect Unit

-- | Native advance width and actual ink extents. Unsupported ink metrics are
-- | NaN, leaving fallback font/measurement policy to the caller.
measureTextInk
  :: Context2D
  -> String
  -> Effect { width :: Number, ascent :: Number, descent :: Number }
measureTextInk = runEffectFn2 measureTextInkImpl

data FillRule = NonZero | EvenOdd

clipWithRule :: Context2D -> FillRule -> Effect Unit
clipWithRule ctx rule = runEffectFn2 clipWithRuleImpl ctx case rule of
  NonZero -> "nonzero"
  EvenOdd -> "evenodd"

-- | Set a CSS filter string without imposing a particular filter recipe.
setFilter :: Context2D -> String -> Effect Unit
setFilter = runEffectFn2 setFilterImpl

-- | Like `Graphics.Canvas.createPattern`, but retain native allocation failure.
createPatternNullable
  :: Context2D -> CanvasImageSource -> PatternRepeat -> Effect (Nullable CanvasPattern)
createPatternNullable ctx source repeat = createPatternNullableImpl ctx source case repeat of
  Repeat -> "repeat"
  RepeatX -> "repeat-x"
  RepeatY -> "repeat-y"
  NoRepeat -> "no-repeat"

-- | Apply a DOMMatrix2DInit directly; no DOMMatrix constructor is needed in
-- | workers. Returns false if this browser does not support pattern transforms.
setPatternTransform :: CanvasPattern -> Transform -> Effect Boolean
setPatternTransform = runEffectFn2 setPatternTransformImpl

foreign import createOffscreenCanvasImpl :: EffectFn2 Number Number CanvasElement
foreign import measureTextInkImpl
  :: EffectFn2 Context2D String { width :: Number, ascent :: Number, descent :: Number }

foreign import clipWithRuleImpl :: EffectFn2 Context2D String Unit
foreign import setFilterImpl :: EffectFn2 Context2D String Unit
foreign import createPatternNullableImpl
  :: Context2D -> CanvasImageSource -> String -> Effect (Nullable CanvasPattern)

foreign import setPatternTransformImpl :: EffectFn2 CanvasPattern Transform Boolean
