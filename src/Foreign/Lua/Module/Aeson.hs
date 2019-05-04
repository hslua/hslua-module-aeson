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
  ( pushModule )
where

import Foreign.Lua (Lua, NumResults)
import qualified Foreign.Lua as Lua

pushModule :: Lua NumResults
pushModule = do
  Lua.newtable
  return 1
