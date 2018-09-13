module WebSQL.API where

import Prelude

import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, EffectFn4, EffectFn5)
import Foreign (Foreign)

foreign import data SQLError :: Type

type SQLResultSet = {
  insertId :: Int
, rowsAffected :: Int
, rows :: SQLResultSetRowList
}

type SQLResultSetRowList = {
  length :: Int
, item :: Int -> Nullable Foreign
}

type Database = {
  transaction :: EffectFn3 (EffectFn1 SQLTransaction Unit) (Nullable (EffectFn1 SQLError Unit)) (Nullable (Effect Unit)) Unit
, readTransaction :: EffectFn3 (EffectFn1 SQLTransaction Unit) (Nullable (EffectFn1 SQLError Unit)) (Nullable (Effect Unit)) Unit
, version :: String
--, changeVersion
}

-- using newtype to avoid cycle
newtype SQLTransaction = SQLTransaction {
  executeSql :: EffectFn4 String (Nullable (Array Foreign)) (Nullable (EffectFn2 SQLTransaction SQLResultSet Unit)) (Nullable (EffectFn2 SQLTransaction SQLError Unit)) Unit
}

foreign import openDatabase :: EffectFn5 String String String Int (Nullable (EffectFn1 Database Unit)) Database

-- TODO: openDatabaseSync

