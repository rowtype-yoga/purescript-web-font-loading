-- | Binary assets embedded by the configurable font-loading Vite plugin.
module Web.Font.Loading.Assets (binaryAsset) where

import Data.ArrayBuffer.Types (ArrayBuffer)
import Effect (Effect)

foreign import binaryAsset :: String -> Effect ArrayBuffer
