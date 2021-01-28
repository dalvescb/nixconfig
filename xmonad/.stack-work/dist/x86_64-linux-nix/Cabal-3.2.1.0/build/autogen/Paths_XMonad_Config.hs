{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_XMonad_Config (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/dalvescb/nixconfig/xmonad/.stack-work/install/x86_64-linux-nix/e91da91a67390d3c4bd703b5f2cbf414b5b56359e37d591a13017895d69c9bc6/8.10.3/bin"
libdir     = "/home/dalvescb/nixconfig/xmonad/.stack-work/install/x86_64-linux-nix/e91da91a67390d3c4bd703b5f2cbf414b5b56359e37d591a13017895d69c9bc6/8.10.3/lib/x86_64-linux-ghc-8.10.3/XMonad-Config-0.1.0.0-HAaDg0BVf1NCBLvSkd1wmI"
dynlibdir  = "/home/dalvescb/nixconfig/xmonad/.stack-work/install/x86_64-linux-nix/e91da91a67390d3c4bd703b5f2cbf414b5b56359e37d591a13017895d69c9bc6/8.10.3/lib/x86_64-linux-ghc-8.10.3"
datadir    = "/home/dalvescb/nixconfig/xmonad/.stack-work/install/x86_64-linux-nix/e91da91a67390d3c4bd703b5f2cbf414b5b56359e37d591a13017895d69c9bc6/8.10.3/share/x86_64-linux-ghc-8.10.3/XMonad-Config-0.1.0.0"
libexecdir = "/home/dalvescb/nixconfig/xmonad/.stack-work/install/x86_64-linux-nix/e91da91a67390d3c4bd703b5f2cbf414b5b56359e37d591a13017895d69c9bc6/8.10.3/libexec/x86_64-linux-ghc-8.10.3/XMonad-Config-0.1.0.0"
sysconfdir = "/home/dalvescb/nixconfig/xmonad/.stack-work/install/x86_64-linux-nix/e91da91a67390d3c4bd703b5f2cbf414b5b56359e37d591a13017895d69c9bc6/8.10.3/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "XMonad_Config_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "XMonad_Config_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "XMonad_Config_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "XMonad_Config_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "XMonad_Config_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "XMonad_Config_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
