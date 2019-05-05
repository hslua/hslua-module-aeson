{-|
Module      : Foreign.Lua.Module.Aeson
Copyright   : © 2019 Albert Krewinkel
License     : MIT
Maintainer  : Albert Krewinkel <albert+hslua@zeitkraut.de>
Stability   : alpha
Portability : Requires GHC 8 or later.

Use Aeson to encode and decode Lua values.
-}
module Foreign.Lua.Module.Aeson
  ( pushModule
  , decode
  , encode
  )
where

import Data.ByteString.Lazy (ByteString)
import Foreign.Lua.Aeson (pushNull)
import Foreign.Lua (Lua, NumResults, Optional (..))
import qualified Data.Aeson as Aeson
import qualified Foreign.Lua as Lua

-- | Push the Aeson module on the Lua stack.
pushModule :: Lua NumResults
pushModule = do
  Lua.newtable
  pushNull
  Lua.setfield (Lua.nthFromTop 2) "null"
  Lua.addfunction "decode" decode
  Lua.addfunction "encode" encode
  return 1

-- | Decode a JSON string to Lua values.
decode :: ByteString -> Lua (Optional Aeson.Value)
decode = return . Optional . Aeson.decode

-- | Encode a Lua value as JSON.
encode :: Aeson.Value -> Lua ByteString
encode = return . Aeson.encode

