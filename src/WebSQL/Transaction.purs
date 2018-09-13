module WebSQL.Transaction where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (toNullable)
import Effect (Effect)
import Effect.Uncurried (mkEffectFn2, runEffectFn4)
import Foreign (Foreign)
import WebSQL.API (SQLError, SQLResultSet, SQLTransaction(..))

executeSql ::
  SQLTransaction
  -> String
  -> Maybe (Array Foreign)
  -> Maybe (SQLTransaction -> SQLResultSet -> Effect Unit)
  -> Maybe (SQLTransaction -> SQLError -> Effect Unit)
  -> Effect Unit
executeSql (SQLTransaction transaction) sqlStatement mArguments mCallback mErrorCallback =
  runEffectFn4 transaction.executeSql
    sqlStatement
    (toNullable mArguments)
    (toNullable $ mkEffectFn2 <$> mCallback)
    (toNullable $ mkEffectFn2 <$> mErrorCallback)
