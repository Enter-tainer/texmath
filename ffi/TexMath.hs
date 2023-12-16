{-# LANGUAGE ForeignFunctionInterface #-}

module TexMath (tex2typ) where

import Foreign.C.String
import System.IO.Unsafe
import Data.Text (unpack, pack)
import Text.TeXMath (readTeX, writeTypst, DisplayType(..))
foreign export ccall "tex2typ" tex2typ :: CString -> CString

tex2typ :: CString -> CString
-- use unsafe perform io
tex2typ cstr = unsafePerformIO $ do
    str <- peekCString cstr
    case readTeX $ pack str of
        Left err -> newCString $ "error: " ++ (unpack err)
        Right exps -> newCString $ unpack $ writeTypst DisplayInline exps
