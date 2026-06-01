-- | Bindings to the CSS Font Loading API on `document.fonts`.
-- |
-- | The browser only guarantees a requested font face is available to draw with
-- | once it has been loaded; `loadFont` resolves when the matching faces are
-- | ready, so a caller can repaint with the real face instead of a fallback.
module Web.Font.Loading
  ( FontShorthand(..)
  , loadFont
  , fontsReady
  ) where

import Prelude

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
