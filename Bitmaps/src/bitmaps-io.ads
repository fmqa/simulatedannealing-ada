with Ada.Streams;
with Bitmaps.RGB;

package Bitmaps.IO is

   procedure Write_PPM_P6(To : not null access Ada.Streams.Root_Stream_Type'Class;
                          Source : in Bitmaps.RGB.Image);

end Bitmaps.IO;
