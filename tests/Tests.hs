{-# LANGUAGE OverloadedStrings #-}
module Tests where
import qualified Data.ByteString as BS
import Test.Hspec
import Test.QuickCheck
import Control.Exception
import GEOS.Types
import GEOS.Serialize
import GEOS.Raw.Base
import GEOS.Geometry
import qualified Data.Vector as V
import qualified GEOS.Raw.CoordSeq as RC
import qualified GEOS.Raw.Geometry as R 
import GHC.Conc.Sync (pseq)

polygonBS = "0103000020E6100000010000000C00000073E92D50491A5DC024275C1ED5DE404076E933474C1A5DC02C279CD7DBDE40406EE9A178431A5DC034271059E6DE40406DE9851C431A5DC034271C7AE6DE40406CE9F7AA421A5DC03427A07DE6DE40406CE92B3B421A5DC03427E05BE6DE40406CE955E4411A5DC03427A023E6DE404066E9E9FB3B1A5DC0282718AAD8DE404062E905D4381A5DC02027E877D1DE40406CE95FF8411A5DC014274C4CC6DE40406CE9B5EC421A5DC01427C8A2C6DE404073E92D50491A5DC024275C1ED5DE4040" :: BS.ByteString

linestringBS = "0102000020E610000037000000603A02BC406A5DC020650408151C4140643A94BD436A5DC020659862171C4140693A684D496A5DC01865E0D70E1C4140703AD69C4F6A5DC0146520320B1C4140753A7462556A5DC0146570780B1C41407B3A6CFB5A6A5DC0186534680C1C4140823A5295626A5DC0186500D80C1C4140863AC848666A5DC018659C390F1C4140883A5E29686A5DC01C65985A101C41408A3A6C466A6A5DC0186538520F1C41408E3A0AF06D6A5DC01865A0B00C1C4140923A4619726A5DC01865B4CA0B1C41409A3A30547A6A5DC01065D8E7061C41409D3AEEDE7C6A5DC01065A855051C41409F3AA2FB7E6A5DC010650095041C4140A03A6258806A5DC010656CDD041C4140A23A2EA9816A5DC01065484D041C4140A43AB895836A5DC00C658C83021C4140A63A78A6856A5DC00C6594E4021C4140AC3A24218C6A5DC00C65040C021C4140AE3AAE598D6A5DC00C6594E4021C4140AF3AF6798E6A5DC0106530CD051C4140B03A5CD68F6A5DC01465887F0A1C4140B23A103F916A5DC01865A8980D1C4140B43ACAFB926A5DC0186568A90F1C4140B53A90AC946A5DC01C656432121C4140B63A9060956A5DC02065087C151C4140B63A8A0C956A5DC02465E0DC181C4140B33A9A77926A5DC02865FC161D1C4140B23A76E7916A5DC02C654C00201C4140B23AF856916A5DC0306560D9231C4140B03A5636906A5DC03065383A271C4140AF3A026E8E6A5DC0386514852D1C4140AE3AC6F58D6A5DC03C6504662F1C4140AE3ADEDD8D6A5DC0406538F0341C4140AE3AAE0D8E6A5DC04065F800371C4140B23A76E7916A5DC0546534FF471C4140B83AB0C5976A5DC05C653063511C4140BA3A345E996A5DC06465B84D571C4140BC3A12AB9B6A5DC06C6510D05E1C4140C23A3A41A16A5DC07C6524F76E1C4140C43A5452A36A5DC08065B49F721C4140C63A329FA56A5DC080651C71751C4140CC3A12C9AA6A5DC0846584AA791C4140CF3A7A4EAE6A5DC08865EC7B7C1C4140D43A5424B36A5DC08C658C4E821C4140D53A8AFCB36A5DC09065883F861C4140D63A3811B56A5DC0946538C9881C4140D73AA40DB66A5DC0946580E9891C4140D83A28A6B76A5DC094655C59891C4140DA3A8E02B96A5DC09465E468881C4140DC3AAC00BB6A5DC0946538C9881C4140DE3A027CBC6A5DC09465D828891C4140DF3AB224BE6A5DC09465FC5E891C4140E33ABCBCC16A5DC094659C0A891C4140" :: BS.ByteString

linestring = LineStringGeometry (LineString {unLineString = V.fromList [Coordinate2 (-117.66020107476788) 34.21939182486153,Coordinate2 (-117.66038455462837) 34.21946365777171,Coordinate2 (-117.66072402170688) 34.21920298058302,Coordinate2 (-117.66110917015772) 34.219091668908874,Coordinate2 (-117.66146146154809) 34.219100050812045,Coordinate2 (-117.66180310792144) 34.21912863310189,Coordinate2 (-117.66226704626209) 34.21914196032793,Coordinate2 (-117.66249293855262) 34.21921463142843,Coordinate2 (-117.662607519169) 34.21924908105049,Coordinate2 (-117.66273651665884) 34.21921756509454,Coordinate2 (-117.66296006201648) 34.219137266462155,Coordinate2 (-117.66321403368264) 34.219109857638784,Coordinate2 (-117.66371636113982) 34.218960743581306,Coordinate2 (-117.66387151016757) 34.218912799095165,Coordinate2 (-117.66400042383837) 34.218889832680475,Coordinate2 (-117.66408357231785) 34.21889846604074,Coordinate2 (-117.66416387095026) 34.21888128313924,Coordinate2 (-117.66428130141372) 34.218826716949565,Coordinate2 (-117.66440736523745) 34.21883828397594,Coordinate2 (-117.66480282342917) 34.21881246771417,Coordinate2 (-117.6648773385484) 34.21883828397594,Coordinate2 (-117.66494607015441) 34.218927048330556,Coordinate2 (-117.66502913481486) 34.21907037887482,Coordinate2 (-117.66511513314143) 34.21916492674262,Coordinate2 (-117.66522116421658) 34.21922795865447,Coordinate2 (-117.66532434544463) 34.21930532362077,Coordinate2 (-117.66536726078888) 34.219405655001765,Coordinate2 (-117.6653472280403) 34.2195087524108,Coordinate2 (-117.66518964826064) 34.21963774990064,Coordinate2 (-117.66515528245762) 34.21972659807429,Coordinate2 (-117.66512083283558) 34.21984402853775,Coordinate2 (-117.66505201741052) 34.21994712594676,Coordinate2 (-117.66494322030734) 34.22013915534848,Coordinate2 (-117.66491455419848) 34.2201964875662,Coordinate2 (-117.66490885450432) 34.2203655505532,Coordinate2 (-117.66492025389263) 34.22042858246505,Coordinate2 (-117.66515528245762) 34.22094717081441,Coordinate2 (-117.66551344118022) 34.221233748083904,Coordinate2 (-117.6656108388951) 34.221414294278276,Coordinate2 (-117.66575123577326) 34.22164345551104,Coordinate2 (-117.66609221159436) 34.222136395236674,Coordinate2 (-117.66621835923712) 34.22224804218695,Coordinate2 (-117.66635875611527) 34.22233404051349,Coordinate2 (-117.66667391567461) 34.222462954184294,Coordinate2 (-117.66688882767197) 34.22254895251086,Coordinate2 (-117.66718395448271) 34.22272664885813,Coordinate2 (-117.66723550318723) 34.22284692916867,Coordinate2 (-117.6673014687652) 34.222924377954,Coordinate2 (-117.66736165082999) 34.222958743757005,Coordinate2 (-117.66745904854486) 34.2229415608555,Coordinate2 (-117.66754211320531) 34.222912894746656,Coordinate2 (-117.66766373462036) 34.222924377954,Coordinate2 (-117.66775417535561) 34.222935777342315,Coordinate2 (-117.66785542874594) 34.22294223140776,Coordinate2 (-117.668074783152) 34.22293217312395]}) 4326


main :: IO ()
main = hspec $ do
  describe "raw geometry" $ do
    it "Creates a Coordinate Sequence" $  do
      let (size, dim) = runGeos $ do 
          cs <- RC.createCoordinateSequence 2 2
          size <-  RC.getCoordinateSequenceSize cs 
          dim <-  RC.getCoordinateSequenceDimensions cs
          return (size, dim)
      size `shouldBe` (2 :: Int)
      dim `shouldBe` (2 :: Int)
    it "Sets a Coordinate Sequence" $ do
      let (d1, d2) = runGeos $ do
          cs <-  RC.createCoordinateSequence 2 2
          RC.setCoordinateSequenceX cs 0 5.0 
          d1 <- RC.getCoordinateSequenceX cs 0
          RC.setCoordinateSequenceY cs 1 10.0 
          d2 <- RC.getCoordinateSequenceY cs 1
          return (d1, d2)
      d1 `shouldBe` (5.0 :: Double)
      d2 `shouldBe` (10.0 :: Double)
    it "Creates a LineString " $ do
      let tid = runGeos $ do
          cs <- RC.createCoordinateSequence 2 2
          ls <- R.createLineString cs
          R.getTypeId ls
      tid `shouldBe` 1
      
    it "Creates a Geometry" $ do
      pending
    it "Converts a LineString" $ do
      pending
      {-let tid = runGeos $ do-}
          {-l <- convertGeometryToRaw linestring-}
          {-R.getTypeId l-}
      {-tid `shouldBe` 1-}
      {-let lsr = convertGeometryToRaw cHandle linestring-}
          {-nls = convertGeometryFromRaw cHandle lsr-}
      {-nls `shouldBe` linestring-}
      
  describe "Tests Serialization" $ do
    it "Parses a bytestring to a linestring" $ do
      readHex linestringBS `shouldBe` linestring 
    {-it "Serializes a LineString into a bytestring" $-}
      {-writeHex linestring `shouldBe` linestringBS-}
