{-# LANGUAGE OverloadedStrings #-}
{-|
Module      : Main
Copyright   : © 2019 Albert Krewinkel
License     : MIT
Maintainer  : Albert Krewinkel <albert+hslua@zeitkraut.de>
Stability   : alpha
Portability : Requires language extensions ForeignFunctionInterface,
              OverloadedStrings.

Tests for the Aeson Lua module.
-}

import Control.Monad (void, when)
import Foreign.Lua (Lua)
import Foreign.Lua.Module.Aeson (pushModule)
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (assertEqual, testCase)

import qualified Foreign.Lua as Lua

main :: IO ()
main = defaultMain $ testGroup "hslua-module-system" [tests]

-- | HSpec tests for the Lua 'system' module
tests :: TestTree
tests = testGroup "HsLua Aeson module"
  [ testCase "can be pushed to the stack" $
      Lua.run (void pushModule)

  , testCase "can be added to the preloader" . Lua.run $ do
      Lua.openlibs
      Lua.preloadhs "json" pushModule
      assertEqual' "function not added to preloader" Lua.TypeFunction =<< do
        Lua.getglobal' "package.preload.json"
        Lua.ltype (-1)

  , testCase "can be loaded as json" . Lua.run $ do
      Lua.openlibs
      Lua.requirehs "json" (void pushModule)
      assertEqual' "loading the module fails " Lua.OK =<<
        Lua.dostring "require 'json'"

  , testCase "passes Lua tests" . Lua.run $ do
      Lua.openlibs
      Lua.requirehs "aeson" (void pushModule)
      assertEqual' "error while running lua tests" Lua.OK =<< do
        st <- Lua.loadfile "test/aeson-module-tests.lua"
        when (st == Lua.OK) $ Lua.call 0 0
        return st
  ]

assertEqual' :: (Show a, Eq a) => String -> a -> a -> Lua ()
assertEqual' msg expected = Lua.liftIO . assertEqual msg expected
