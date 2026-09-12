-- | Bindings to the CSS Font Loading API in documents and workers.
-- |
-- | The browser only guarantees a requested font face is available to draw with
-- | once it has been loaded; `loadFont` resolves when the matching faces are
-- | ready, so a caller can repaint with the real face instead of a fallback.
module Web.Font.Loading
  ( FontShorthand(..)
  , loadFont
  , fontsReady
  , checkFont
  , hasFontSet
  , supportsFontFace
  , FontFace
  , newFontFace
  , loadFontFace
  , addFontFace
  ) where

import Prelude
import Data.ArrayBuffer.Types (ArrayBuffer)

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Promise (Promise)
import Promise.Aff (toAffE)

-- | A CSS font shorthand, as accepted by `document.fonts.load` and the 2D
-- | context `font` property, e.g. `800 144px "Sinistre", serif`.
newtype FontShorthand = FontShorthand String

derive newtype instance Eq FontShorthand
derive newtype instance Ord FontShorthand
derive newtype instance Show FontShorthand

-- | Load the font faces matching a shorthand, resolving once they are usable.
-- | Resolves immediately when the Font Loading API is unavailable (e.g. SSR).
loadFont :: FontShorthand -> Aff Unit
loadFont font = toAffE (runEffectFn1 loadFontImpl font)

foreign import loadFontImpl :: EffectFn1 FontShorthand (Promise Unit)

-- | Resolves once every pending font in the document has settled.
fontsReady :: Aff Unit
fontsReady = toAffE fontsReadyImpl

foreign import fontsReadyImpl :: Effect (Promise Unit)

-- | Native font checks require an available font set; callers choose fallback
-- | policy by querying `hasFontSet` first.
foreign import checkFont :: FontShorthand -> Effect Boolean
foreign import hasFontSet :: Effect Boolean
foreign import supportsFontFace :: Effect Boolean
foreign import data FontFace :: Type

foreign import newFontFace
  :: String
  -> ArrayBuffer
  -> { weight :: String, display :: String }
  -> Effect FontFace

loadFontFace :: FontFace -> Aff Unit
loadFontFace = toAffE <<< loadFontFaceImpl

foreign import loadFontFaceImpl :: FontFace -> Effect (Promise Unit)
foreign import addFontFace :: FontFace -> Effect Unit
