with Ada.Numerics.Discrete_Random;
with Bitmaps.RGB;
with ImageOps;

package body Problem is

   package Random_Direction is new Ada.Numerics.Discrete_Random(Direction);

   package Random_Natural is new Ada.Numerics.Discrete_Random(Natural);

   Random_Direction_G : Random_Direction.Generator;
   Random_Natural_G : Random_Natural.Generator;

   function Objective (S : in State) return Float is
      (Float(S.E));

   procedure Shuffle (S : in State) is
      T : Bitmaps.RGB.Pixel := Bitmaps.RGB.Get_Pixel (S.Img.all, S.X, S.Y);
   begin
      Bitmaps.RGB.Set_Pixel
        (Target => S.Img.all, X => S.X, Y => S.Y,
         Value  => Bitmaps.RGB.Get_Pixel (S.Img.all, S.X + S.DX, S.Y + S.DY));
      Bitmaps.RGB.Set_Pixel
        (Target => S.Img.all, X => S.X + S.DX, Y => S.Y + S.DY, Value => T);
   end Shuffle;

   procedure Roll (S : in out State) is
   begin
      S.X := 1 + (Random_Natural.Random(Random_Natural_G) mod (S.Img.Width - 1));
      S.Y := 1 + (Random_Natural.Random(Random_Natural_G) mod (S.Img.Height - 1));
      loop
         S.DX := Random_Direction.Random(Random_Direction_G);
         S.DY := Random_Direction.Random(Random_Direction_G);
         exit when not ((S.DX = 0) and (S.DY = 0));
      end loop;
   end;

   function Mutate(S : in out State) return State is
      T : State := S;
   begin
      if S.Visited then
         Shuffle(S);
         Roll(S);
      end if;

      Shuffle(S);
      S.Visited := True;

      T.Visited := False;
      Roll(T);
      T.E := ImageOps.Adj_Distance_Sum(T.Img.all);

      return T;
   end Mutate;
end Problem;
