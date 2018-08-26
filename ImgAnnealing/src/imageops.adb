with Ada.Numerics.Discrete_Random;
with Bitmaps.RGB;

package body ImageOps is

   package Random_Luminance is new Ada.Numerics.Discrete_Random
     (Bitmaps.Luminance);

   Random_Luminance_G : Random_Luminance.Generator;

   function Manhattan_Distance (A, B : in Bitmaps.RGB.Pixel) return Natural is
     (abs (Integer (A.R) - Integer (B.R)) +
      abs (Integer (A.G) - Integer (B.G)) +
      abs (Integer (A.B) - Integer (B.B)));

   function Adj_Distance_Sum
     (Source : in Bitmaps.RGB.Image) return Long_Integer
   is
      S : Long_Integer := 0;
   begin
      for Y in 1 .. Bitmaps.RGB.Max_Y (Source) loop
         for X in 1 .. Bitmaps.RGB.Max_X (Source) loop

            S :=
              S +
              Long_Integer
                (Manhattan_Distance
                   (Bitmaps.RGB.Get_Pixel (Source, X, Y),
                    Bitmaps.RGB.Get_Pixel (Source, X - 1, Y)));

            S :=
              S +
              Long_Integer
                (Manhattan_Distance
                   (Bitmaps.RGB.Get_Pixel (Source, X, Y),
                    Bitmaps.RGB.Get_Pixel (Source, X, Y - 1)));

         end loop;
      end loop;
      return S;
   end Adj_Distance_Sum;

   procedure Noise (Target : in out Bitmaps.RGB.Image) is
   begin
      for Y in 0 .. Bitmaps.RGB.Max_Y (Target) loop
         for X in 0 .. Bitmaps.RGB.Max_X (Target) loop
            Bitmaps.RGB.Set_Pixel
              (Target, X, Y,
               (R => Random_Luminance.Random (Random_Luminance_G),
                G => Random_Luminance.Random (Random_Luminance_G),
                B => Random_Luminance.Random (Random_Luminance_G)));
         end loop;
      end loop;
   end Noise;

end ImageOps;
