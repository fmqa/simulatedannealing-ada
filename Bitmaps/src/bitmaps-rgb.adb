package body Bitmaps.RGB is
   function Max_X (Source : in Image) return Natural is (Source.Width - 1);
   function Max_Y (Source : in Image) return Natural is (Source.Height - 1);

   function Get_Pixel (Source : in Image; X, Y : Natural) return Pixel is
     (Source.Pixels (Y, X));

   procedure Set_Pixel (Target : in out Image; X, Y : Natural;
      Value                    : in     Pixel)
   is
   begin
      Target.Pixels (Y, X) := Value;
   end Set_Pixel;
end Bitmaps.RGB;
