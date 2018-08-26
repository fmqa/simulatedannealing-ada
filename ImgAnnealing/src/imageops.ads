with Bitmaps.RGB;

package ImageOps is

   function Manhattan_Distance (A, B : in Bitmaps.RGB.Pixel) return Natural;
   function Adj_Distance_Sum
     (Source : in Bitmaps.RGB.Image) return Long_Integer;
   procedure Noise (Target : in out Bitmaps.RGB.Image);

end ImageOps;
