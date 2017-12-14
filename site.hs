--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Text.Pandoc.Options
import           Control.Monad (liftM)
import           Data.Time.Clock               (UTCTime (..))
import           Data.Time.Format              (formatTime)
import qualified Data.Time.Format              as TF
import           Data.Time.Locale.Compat       (TimeLocale, defaultTimeLocale)


--------------------------------------------------------------------------------
baseurl :: String
baseurl = "http://localhost:8000"

myDefaultContext :: Context String
myDefaultContext = constField "rssurl" (baseurl++"/rss.xml") `mappend`
                   getDefaultTime `mappend`
                   defaultContext
                   
main :: IO ()
main = hakyllWith myConfiguration $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "publications/*.bib" $ do
      compile biblioCompiler

    match "publications/*.csl" $ do
      compile cslCompiler

    match "assets/*" $ do
      route idRoute
      compile copyFileCompiler

    match "pages/home.md" $ do
      route idRoute
      compile $ pandocCompiler
        >>= relativizeUrls

    match "pages/publications.md" $ do
      route $ setExtension "html"
      compile $ myPandocBiblioCompiler
        "publications/nature.csl" "publications/publications.bib"
        >>= loadAndApplyTemplate "templates/default.html" myDefaultContext
        >>= relativizeUrls

    match "pages/libraryofwetlandphysics.md" $ do
      route $ setExtension "html"
      compile $ myPandocBiblioCompiler
        "publications/nature.csl" "publications/libraryofwetlandphysics.bib"
        >>= loadAndApplyTemplate "templates/default.html" myDefaultContext
        >>= relativizeUrls
          
    match "pages/*" $ do
        route   $ setExtension "html"
        compile $ pandocCompilerWith defaultHakyllReaderOptions defaultHakyllWriterOptions { writerSectionDivs = True}
          >>= loadAndApplyTemplate "templates/default.html" myDefaultContext
          >>= relativizeUrls
        
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    constField "rss" "/rss.xml"              `mappend`
                    myDefaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
      route idRoute
      compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        home <- loadBody "pages/home.md"
        let indexCtx =              
              listField "posts" postCtx (return posts) `mappend`
              constField "title" "Home"                `mappend`
              field "homebody" (\item -> (return home)) `mappend`
              constField "rss" "/rss.xml" `mappend`
              myDefaultContext

        getResourceBody
          >>= applyAsTemplate indexCtx
          >>= loadAndApplyTemplate "templates/default.html" indexCtx
          >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

    create ["rss.xml"] $ do
      route idRoute
      compile $ do
        let feedCtx = postCtx `mappend` bodyField "description"
        posts <- fmap (take 10) . recentFirst =<<
                 loadAllSnapshots "posts/*" "content"
        renderRss myFeedConfiguration feedCtx posts

    match "CNAME" $ do
      route idRoute
      compile copyFileCompiler
        
--------------------------------------------------------------------------------
myConfiguration :: Configuration
myConfiguration = defaultConfiguration { deployCommand = "./deploy" }

postCtx :: Context String
postCtx =
  dateField "date" "%B %e, %Y" `mappend`
  myDefaultContext

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration = FeedConfiguration
                      { feedTitle = "Will Kearney's Blog"
                      , feedDescription = "Musings from a marsh"
                      , feedAuthorName = "Will Kearney"
                      , feedAuthorEmail = "wkearn@gmail.com"
                      , feedRoot = "http://www.wskearney.com"
                      }

myPandocBiblioCompiler :: String -> String -> Compiler (Item String)
myPandocBiblioCompiler cslFileName bibFileName = do
  csl <- load $ fromFilePath cslFileName
  bib <- load $ fromFilePath bibFileName
  liftM (writePandocWith defaultHakyllWriterOptions { writerSectionDivs = True })
    (getResourceString >>= readPandocBiblio def csl bib)

getDefaultTime :: Context a
getDefaultTime = field "updated" $ \i -> do
  mtime <- getItemModificationTime "timestamp"
  return $ formatTime defaultTimeLocale "%Y-%m-%d %R" mtime
