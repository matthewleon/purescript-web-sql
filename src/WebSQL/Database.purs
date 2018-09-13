module WebSQL.Database where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Nullable (toNullable)
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1, runEffectFn3, runEffectFn5)
import WebSQL.API (Database, SQLError, SQLTransaction)
import WebSQL.API as API

openDatabase :: String -> String -> String -> Int -> Effect Database
openDatabase name version' displayName estimatedSize =
  runEffectFn5 API.openDatabase name version' displayName estimatedSize $ toNullable Nothing

openDatabase'
  :: String
  -> String
  -> String
  -> Int
  -> (Database -> Effect Unit)
  -> Effect Database
openDatabase' name version' displayName estimatedSize creationCallback =
  runEffectFn5 API.openDatabase name version' displayName estimatedSize
  $ toNullable $ Just $ mkEffectFn1 creationCallback

transaction
  :: Database
  -> (SQLTransaction -> Effect Unit)
  -> (Maybe (SQLError -> Effect Unit))
  -> (Maybe (Effect Unit))
  -> Effect Unit
transaction database callback mErrorCallback mSuccessCallback =
  runEffectFn3 database.transaction
    (mkEffectFn1 callback)
    (toNullable $ mkEffectFn1 <$> mErrorCallback)
    (toNullable mSuccessCallback)

version :: Database -> String
version database = database.version
