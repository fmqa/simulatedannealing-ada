with Bitmaps.RGB;
with Simulated_Annealing;

generic
   type Image_Access is access Bitmaps.RGB.Image;
package Problem is
   subtype Direction is Integer range -1 .. 1;

   type State is record
      Img     : Image_Access;
      E       : Long_Integer;
      X, Y    : Natural;
      DX, DY  : Direction;
      Visited : Boolean;
   end record;

   function Objective (S : in State) return Float;
   procedure Shuffle (S : in State);
   procedure Roll (S : in out State);
   function Mutate (S : in out State) return State;

   package Opt is new Simulated_Annealing.Optimization (State, Objective,
      Mutate);

end Problem;
