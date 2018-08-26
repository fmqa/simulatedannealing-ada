with Ada.Characters.Latin_1;
with GNAT.Spitbol;
with Bitmaps.RGB;

package body Bitmaps.IO is
   procedure Write_PPM_P6
     (To     :    not null access Ada.Streams.Root_Stream_Type'Class;
      Source : in Bitmaps.RGB.Image)
   is
   begin
      -- Write P6 PPM type marker.
      String'Write (To, "P6");
      Character'Write (To, Ada.Characters.Latin_1.LF);

      -- Write image dimensions.
      String'Write (To, GNAT.Spitbol.S (Source.Width));
      Character'Write (To, Ada.Characters.Latin_1.Space);
      String'Write (To, GNAT.Spitbol.S (Source.Height));
      Character'Write (To, Ada.Characters.Latin_1.LF);

      -- Write maximum luminance value.
      String'Write (To, GNAT.Spitbol.S (Integer (Luminance'Last)));
      Character'Write (To, Ada.Characters.Latin_1.LF);

      -- RGB component-wise output.
      for Y in 0 .. Bitmaps.RGB.Max_Y (Source) loop
         for X in 0 .. Bitmaps.RGB.Max_X (Source) loop
            declare
               Pxy : Bitmaps.RGB.Pixel := Bitmaps.RGB.Get_Pixel (Source, X, Y);
            begin
               Character'Write (To, Character'Val (Pxy.R));
               Character'Write (To, Character'Val (Pxy.G));
               Character'Write (To, Character'Val (Pxy.B));
            end;
         end loop;
      end loop;

      Character'Write (To, Ada.Characters.Latin_1.LF);
   end Write_PPM_P6;

end Bitmaps.IO;
