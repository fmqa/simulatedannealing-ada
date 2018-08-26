package Bitmaps.RGB is
   type Pixel is record
      R, G, B : Luminance := Luminance'First;
   end record;

   type Raster is array (Natural range <>, Natural range <>) of Pixel;

   type Image (Width, Height : Positive) is record
      Pixels : Raster (0 .. Height, 0 .. Width);
   end record;

   Black : constant Pixel := (others => Luminance'First);
   White : constant Pixel := (others => Luminance'Last);

   function Max_X (Source : in Image) return Natural;
   function Max_Y (Source : in Image) return Natural;

   function Get_Pixel (Source : in Image; X, Y : Natural) return Pixel;
   procedure Set_Pixel (Target : in out Image; X, Y : Natural;
      Value                    : in     Pixel);
end Bitmaps.RGB;
