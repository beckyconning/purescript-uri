module Data.URI.HierarchicalPart where

import Prelude
import Control.Alt ((<|>))
import Control.Apply ((*>))
import Data.Array (catMaybes)
import Data.Maybe (Maybe(..))
import Data.URI.Authority
import Data.URI.Path
import Data.URI.Types
import qualified Data.String as S
import Text.Parsing.StringParser (Parser())
import Text.Parsing.StringParser.String (string)

parseHierarchicalPart :: Parser HierarchicalPart
parseHierarchicalPart = withAuth <|> withoutAuth
  where
  withAuth =
    HierarchicalPart
      <$> Just <$> (string "//" *> parseAuthority)
      <*> parsePathAbEmpty parseURIPathAbs

  withoutAuth = HierarchicalPart Nothing <$> noAuthPath

  noAuthPath
      = (Just <$> parsePathAbsolute parseURIPathAbs)
    <|> (Just <$> parsePathRootless parseURIPathAbs)
    <|> pure Nothing

printHierPart :: HierarchicalPart -> String
printHierPart (HierarchicalPart a p) =
  S.joinWith "" $ catMaybes [ printAuthority <$> a
                            , printPath <$> p
                            ]
